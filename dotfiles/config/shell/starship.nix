_: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      format = ''
        $directory$git_branch$git_status$env_var $cmd_duration
        $character'';

      add_newline = false;

      directory = {
        format = "[$path]($style)[$read_only]($read_only_style)";
        style = "blue";
        read_only = "";
        read_only_style = "yellow";
        truncation_symbol = ".../";
        truncate_to_repo = false;
      };

      character = {
        format = "$symbol ";
        success_symbol = "[\\$](purple)";
        error_symbol = "[\\$](red)";
        vicmd_symbol = "[!](green)";
      };

      cmd_duration = {
        format = "[$duration]($style)";
        style = "yellow";
      };

      git_branch = {
        format = " [$symbol$branch]($style)";
        symbol = "";
        style = "white";
      };

      git_status = { format = " [$ahead_behind](cyan)"; };

      env_var = {
        format = "[](bold gray)[](cyan)";
        variable = "IN_NIX_SHELL";
      };
    };
  };
}
