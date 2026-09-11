set clipboard=unnamed
unmap <Space>

" Commands
exmap quickSwitcher obcommand switcher:open
exmap globalSearch obcommand global-search:open
exmap toggleSidebar obcommand app:toggle-left-sidebar
exmap nextTab obcommand workspace:next-tab
exmap prevTab obcommand workspace:previous-tab

" Space as leader
nmap <Space><Space> :quickSwitcher<CR>
nmap <Space>/ :globalSearch<CR>
nmap <Space>e :toggleSidebar<CR>

" Tab navigation (normal mode only)
nmap H :prevTab<CR>
nmap L :nextTab<CR>
