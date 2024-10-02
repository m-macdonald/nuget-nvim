" Title:        Nuget Nvim
" Description:  A plugin to provide the functionality of the Visual Studio
" Nuget UI within Neovim
" Last Change:  20 September 2024
" Maintainer:   m-macdonald

" Prevents the plugin being loaded multiple times
if exists("g:loaded_nugetnvim")
    finish
endif
let g:loaded_nugetnvim = 1


" Defines a package path for Lua.
let s:lua_rocks_deps_loc = expand("<sfile>:h:r") . "/../lua/nuget-nvim/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugins functions for use as commands in Neovim.
command! -nargs=0 SayHello lua require("nuget-nvim").say_hello()
command! -nargs=0 FindNuget lua require("nuget-nvim").find_nuget()
