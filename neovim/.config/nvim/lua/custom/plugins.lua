local plugins = {
  {
    "hashivim/vim-terraform",
    ft= "terraform",
    config = function(_)
      vim.g.terraform_fmt_on_save = 1
    end
  }
}
return plugins
