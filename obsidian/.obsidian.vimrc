set clipboard=unnamed
unmap <Space>

" Commands
exmap quickSwitcher obcommand switcher:open
exmap globalSearch obcommand global-search:open
exmap toggleSidebar obcommand app:toggle-left-sidebar

" Space as leader
nmap <Space><Space> :quickSwitcher<CR>
nmap <Space>/ :globalSearch<CR>
nmap <Space>e :toggleSidebar<CR>
