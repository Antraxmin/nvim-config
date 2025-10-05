return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Language Servers
        "ansible-language-server",
        "bash-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "markdown-oxide",
        "nginx-language-server",
        "pyright",
        "python-lsp-server",
        "systemd-language-server",
        "typescript-language-server",
        "vim-language-server",
        "yaml-language-server",

        -- Formatters
        "mdformat",
        "nginx-config-formatter",
        "shfmt",
        "stylua",

        -- Linters
        "jsonlint",
        "markdownlint",
        "mypy",
        "pylint",
        "salt-lint",
        "shellcheck",
        "systemdlint",
        "yamllint",

        -- Debug Adapters
        "bash-debug-adapter",

        -- GitHub Actions
        "gh",
        "gh-actions-language-server",
      },
    },
  },
}
