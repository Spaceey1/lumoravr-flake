{
  makeDesktopItem,
  autoPatchelfHook,
  copyDesktopItems,
  stdenv,
  lib,
  makeWrapper,
  fetchzip,
  wayland,
  libxkbcommon,
  vulkan-loader,
  lttng-ust_2_12,
  libz,
  icu,
  noto-fonts-color-emoji,
  fontconfig,
  openssl,
}:
let
  version = "2026.05.07.2";
  filename = "LumoraVR-${version}-linux-x64.zip";
  pname = "lumora";
  src = fetchzip {
    url = "https://github.com/LackLuster-Labs/LumoraVR/releases/download/v${version}/${filename}";
    sha256 = "sha256-gnurBJ0EavH9yD9l7xEtcpZxmIV+J92I94t0CQl7j2g=";
    stripRoot = false;
  };
  desktopEntry = makeDesktopItem ({
    name = "LumoraVR";
    exec = "LumoraVR";
    desktopName = "LumoraVR";
    icon = "LumoraVR";
    categories = [
      "Network"
      "Game"
    ];
  });
in
stdenv.mkDerivation {
  inherit src pname version;

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc.lib
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [
    wayland
    lttng-ust_2_12
    libz
    icu
    noto-fonts-color-emoji
    fontconfig
    openssl
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -Dm755 LumoraVR.x86_64 $out/bin/LumoraVR
    install -Dm644 LumoraVR.pck $out/bin/LumoraVR.pck
    mkdir $out/bin/data_Lumora_linuxbsd_x86_64/
    cp data_Lumora_linuxbsd_x86_64/* $out/bin/data_Lumora_linuxbsd_x86_64/
    runHook postInstall
  '';
  postFixup = ''
    mkdir -p $out/share/fonts/config/
    cat > $out/share/fonts/config/fonts.conf <<EOF
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <dir>${noto-fonts-color-emoji}/share/fonts/truetype</dir>
      
      <match target="pattern">
        <edit name="family" mode="append"><string>Noto Color Emoji</string></edit>
      </match>
    </fontconfig>
    EOF
    wrapProgram $out/bin/LumoraVR \
    --run "cd $out/bin" \
    --prefix LD_LIBRARY_PATH : "$out/bin/data_Lumora_linuxbsd_x86_64:${
      lib.makeLibraryPath [
        wayland
        libxkbcommon
        vulkan-loader
        icu
        fontconfig
        openssl
      ]
    }"
    ln -s $out/bin/LumoraVR.pck $out/bin/.LumoraVR-wrapped.pck
  '';
  desktopItems = [ desktopEntry ];
  stripExclude = [ "*.dll" ];

}
