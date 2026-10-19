function tfws --description "Print the TFE/HCP Terraform workspace URL for a Terraform directory"
    # Usage: tfws [dir]   (default: current directory)
    #
    # Reads the `cloud {}` / `backend "remote" {}` block. Prefers the resolved
    # backend in .terraform/terraform.tfstate (written by `terraform init`) and
    # falls back to parsing the *.tf files, so it works before init too.
    set -l dir (test -n "$argv[1]"; and echo $argv[1]; or echo .)
    if not test -d $dir
        echo "tfws: $dir: not a directory" >&2
        return 1
    end

    set -l host
    set -l org
    set -l name
    set -l prefix

    # 1. Resolved backend from `terraform init`.
    set -l state $dir/.terraform/terraform.tfstate
    if test -f $state; and command -q jq
        set -l vals (jq -r '
            select(.backend.type == "remote" or .backend.type == "cloud")
            | .backend.config
            | [.hostname, .organization, .workspaces.name, .workspaces.prefix]
            | map(. // "") | .[]' $state 2>/dev/null)
        if test (count $vals) -eq 4
            set host $vals[1]
            set org $vals[2]
            set name $vals[3]
            set prefix $vals[4]
        end
    end

    # 2. Fall back to the HCL source.
    if test -z "$org"
        set -l tf_files $dir/*.tf
        if test (count $tf_files) -gt 0
            set -l vals (awk '
                { sub(/(#|\/\/).*/, "") }   # drop comments
                !done && !inblk && /^[ \t]*(cloud[ \t]*\{|backend[ \t]*"remote"[ \t]*\{)/ { inblk = 1; depth = 0 }
                inblk {
                    rest = $0
                    while (match(rest, /(^|[^A-Za-z0-9_])(hostname|organization|name|prefix)[ \t]*=[ \t]*"[^"]*"/)) {
                        line = substr(rest, RSTART, RLENGTH)
                        rest = substr(rest, RSTART + RLENGTH)
                        key = line; sub(/^[^A-Za-z]*/, "", key); sub(/[ \t]*=.*/, "", key)
                        val = line; sub(/^[^"]*"/, "", val); sub(/"$/, "", val)
                        if (!(key in kv)) kv[key] = val
                    }
                    depth += gsub(/\{/, "{") - gsub(/\}/, "}")
                    if (depth <= 0) { inblk = 0; done = 1 }
                }
                END {
                    if (done || inblk)
                        printf "%s\n%s\n%s\n%s\n", kv["hostname"], kv["organization"], kv["name"], kv["prefix"]
                }' $tf_files)
            if test (count $vals) -eq 4
                set host $vals[1]
                set org $vals[2]
                set name $vals[3]
                set prefix $vals[4]
            end
        end
    end

    # cloud {} block env-var fallbacks.
    test -z "$host"; and set host $TF_CLOUD_HOSTNAME
    test -z "$org"; and set org $TF_CLOUD_ORGANIZATION
    test -z "$host"; and set host app.terraform.io

    # No fixed name: prefix/tags workspaces use the selected workspace.
    if test -z "$name"
        set -l selected $TF_WORKSPACE
        if test -z "$selected"; and test -f $dir/.terraform/environment
            set selected (string trim < $dir/.terraform/environment)
        end
        if test -n "$selected"
            set name "$prefix$selected"
        end
    end

    if test -z "$org"; or test -z "$name"
        echo "tfws: no TFE cloud/remote backend workspace found in $dir" >&2
        return 1
    end

    echo "https://$host/app/$org/workspaces/$name"
end
