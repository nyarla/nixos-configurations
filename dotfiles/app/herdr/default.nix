{
  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;

      theme.name = "terminal";

      keys = {
        prefix = "ctrl+t";
        split_vertical = "prefix+|";
        split_horizontal = "prefix+minus";

        focus_pane_left = "ctrl+left";
        focus_pane_right = "ctrl+right";
        focus_pane_up = "ctrl+up";
        focus_pane_down = "ctrl+down";

        swap_pane_left = "shift+left";
        swap_pane_right = "shift+right";
        swap_pane_up = "shift+up";
        swap_pane_down = "shift+down";
      };

      ui = {
        prompt_new_tab_name = false;
      };

      experimental = {
        reveal_hidden_cursor_for_cjk_ime = true;
        cjk_ime_agents = [ "pi" ];
      };
    };
  };
}
