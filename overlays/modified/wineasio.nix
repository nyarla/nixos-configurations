self: super: {
  qjackctl = super.qjackctl.override { libjack2 = super.jack1; };

  wineWithWineASIO = let
    wineasio = super.fetchurl {
      url = "https://github.com/jhernberg/wineasio/archive/master.tar.gz";
      sha256 = "0c7xqkk2i3y9gxq80mvvhx3nbgi0bq2gbqpgnlzxdld9a3k3pipb";
    };

    asiosdk = super.fetchurl {
      url = "http://www.steinberg.net/sdk_downloads/asiosdk2.3.zip";
      sha256 = "16qvyfc5hnsy9pgzq3xgxmlm799rb6spcq2cg1lgajhlx4h508k9";
    };

    toBuildInputs = arch: pkgs: super.lib.concatList (map pkgs arch);
    overrideAttrs = wine:
      super.lib.overrideDerivation wine (old: rec {
        buildInputs = old.buildInputs
          ++ (toBuildInputs [ super.pkgs super.pkgsi686Linux ]
            (pkgs: [ pkgs.jack1 ]));

        nativeBuildInputs = old.nativeBuildInputs
          ++ (with super; [ ed gnused unzip ]);

        postInstall = old.postInstall + ''
          cd ../

          tar -zxvf ${wineasio}
          unzip -d asiosdk ${asiosdk}

          export PREFIX=$out
          export PATH=$PREFIX/bin:$PATH
          export CFLAGS="$NIX_CFLAGS_COMPILE"
          cd wineasio-master
          cp ../asiosdk/ASIOSDK2.3/common/asio.h .
          cp asio.h asio.h.i686
          if test -e $PREFIX/lib64 ; then
            chmod +w asio.h
            ${super.bash}/bin/bash ./prepare_64bit_asio
            sed -i "s!-L/usr/lib!-L$PREFIX/lib64!g" Makefile64
            make -f Makefile64 PREFIX=$PREFIX
            mv wineasio.dll.so $PREFIX/lib64/wine/
            make clean
          fi
          if test -e $PREFIX/lib ; then
            cp asio.h.i686 asio.h
            sed -i "s!-L/usr/lib32!-L$PREFIX/lib!g" Makefile
            make -f Makefile PREFIX=$PREFIX
            mv wineasio.dll.so $PREFIX/lib/wine
          fi
        '';
      });
  in overrideAttrs (super.wineUnstable.override { wineBuild = "wineWow"; });
}
