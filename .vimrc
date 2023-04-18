" Some basics
  syntax on
  set encoding=utf-8

" Interface
  set number
  colorscheme elflord
  set winheight=30

" Text formatting
  set shiftwidth=2

" Spellchecking
  if has("spell")
    " turn spelling on by default
    set spell

    " toggle spelling with F4 key
    map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

    " they were using white on white
    highlight PmenuSel ctermfg=black ctermbg=lightgray

    " limit it to just the top 10 items
    set sps=best,10                    
  endif
