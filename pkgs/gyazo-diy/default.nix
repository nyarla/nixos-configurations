{
  lib,
  writeShellScriptBin,

  coreutils,
  curl,
  jq,
  libnotify,
  xdg-utils,
}:
writeShellScriptBin "gyazo" ''
  export PATH=${
    lib.makeBinPath [
      coreutils
      curl
      jq
      libnotify
      xdg-utils
    ]
  }:$PATH

  source $HOME/.config/gyazo/env

  main() {
    local fn
    fn="''${1:-1}"

    if [[ -z "''${fn}" ]]; then
      notify-send -u critical -t 5000 "ファイル名が空です" 
      exit 1
    fi

    local href
    href=$(curl -s \
      -F access_token=''${ACCESS_TOKEN} \
      -F imagedata=@''${fn} \
      -F created_at=$(date +%s) \
      -F collection_id=''${COLLECTION_ID} \
      https://upload.gyazo.com/api/upload | jq -r .permalink_url)
    
    if [[ -z "''${href}" ]]; then
      notify-send -u critical -t 5000 "アップロードに失敗しました"
      exit 1
    else
      notify-send -u low -t 3000 "アップロード成功！"
      xdg-open $href &
    fi

    exit 0
  }

  main "''${@:-}" 
''
