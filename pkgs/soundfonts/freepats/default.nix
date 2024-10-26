{ lib, stdenv, fetchurl, p7zip }:
  map
    ({pname, version, fname, license, url, sha256, homepage}:
      stdenv.mkDerivation {
        pname = "freepats-${pname}";
        version = "unstable-${version}";

        buildInputs = [ p7zip ];
        src = fetchurl { inherit url sha256; };

        unpackCmd = ''
          if [[ $curSrc == "*.7z" ]]; then
            7z x "$curSrc"
          elif [[ $curSrc == "*.tar.*" ]]; then
            tar xf "$curSrc"
          else
            echo Unrecognised format $curSrc
            return 1
          fi
        '';

        installPhase = ''
          find . -type f -exec install -Dm 755 "{}" "$out/share/soundfonts/${fname}/{}" \;
        '';

        phases = ["unpackPhase" "installPhase"];

        meta = with lib; {
          inherit license homepage;
          platforms = platforms.all;
        };
      })
  [
    {
      pname = "upright-piano-kw";
      fname = "UprightPianoKW";
      version = "2022-02-21";
      url = "https://freepats.zenvoid.org/Piano/UprightPianoKW/UprightPianoKW-SFZ+FLAC-20220221.7z";
      sha256 = "sha256-OmbaOyWi/ZSZ2QvPCfGu5EMYJXluJJNhtIr1mxIB5wM=";
      homepage = "https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html";
      license = lib.licenses.cc0;
    }
    # SF2 only - already packaged on nixpkgs
    #{
    #  pname = "ydp-grand-piano";
    #  version = "2016-08-04";
    #  url = "https://freepats.zenvoid.org/Piano/YDP-GrandPiano/YDP-GrandPiano-SF2-20160804.tar.bz2";
    #  sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
    #  homepage = "https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html";
    #  license = lib.licenses.cc-by-30;
    #}
    {
      pname = "salamander-grand-piano";
      fname = "SalamanderGrandPiano";
      version = "2020-06-02";
      url = "https://freepats.zenvoid.org/Piano/SalamanderGrandPiano/SalamanderGrandPiano-SFZ+FLAC-V3+20200602.tar.gz";
      sha256 = "sha256-t3YOFoSUzwlTROIXsK8BP8RJrQM6u73xxlIRzxHcA4s=";
      homepage = "https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html";
      license = lib.licenses.cc-by-30;
    }
    {
      pname = "old-piano-fb";
      fname = "PianoFB";
      version = "2020-04-01";
      url = "https://github.com/freepats/old-piano-FB/releases/download/2020-04-01/PianoFB-SFZ+FLAC-20200401.7z";
      sha256 = "sha256-2jXJOWfEIbF/chnBKjeDD/0rGfVPigpxID/GFhsHm0U=";
      homepage = "https://freepats.zenvoid.org/Piano/honky-tonk-piano.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "fm-piano1";
      fname = "FM-Piano1";
      version = "2020-04-01";
      url = "https://github.com/freepats/fm-piano1/releases/download/2019-09-16/FM-Piano1-SFZ+FLAC-20190916.7z";
      sha256 = "sha256-+jCM6tYXIRsp9QDbL5YvNOGMnNValK6RduHWO6vqsIM=";
      homepage = "https://freepats.zenvoid.org/ElectricPiano/synthesized-piano.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "fm-piano2";
      fname = "FM-Piano2";
      version = "2016-11-12";
      url = "https://github.com/freepats/fm-piano2/releases/download/2016-11-12/FM-Piano2-SFZ+FLAC-20161112.7z";
      sha256 = "sha256-ThGkQvqba1Mi5d+k6ySr38hxO7mn7DPJm6qx+Slnqqo=";
      homepage = "https://freepats.zenvoid.org/ElectricPiano/synthesized-piano.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "glass";
      fname = "Glass";
      version = "2019-12-27";
      url = "https://freepats.zenvoid.org/ChromaticPercussion/Glass/Glass-SFZ+FLAC-20191227.7z";
      sha256 = "sha256-CeeUWOQqQ135OlVMkPYQgicLs7r133BR9NyvCaqsm5o=";
      homepage = "https://freepats.zenvoid.org/ChromaticPercussion/glass.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "hang";
      fname = "Hand-D-Minor";
      version = "2022-03-30";
      url = "https://github.com/freepats/hang-D-minor/releases/download/2022-03-30/Hang-D-minor-SFZ+FLAC-20220330.7z";
      sha256 = "sha256-3qVqiYyIuDjjf5KWf+Dt/kGxvSqhbtmiQOP0TvtSWlw=";
      homepage = "https://freepats.zenvoid.org/ChromaticPercussion/hang.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "tubular-bells";
      fname = "TubularBells";
      version = "2020-07-29";
      url = "https://freepats.zenvoid.org/ChromaticPercussion/TubularBells/TubularBells-SFZ+FLAC-20200729.tar.gz";
      sha256 = "sha256-hi/goJd2GriQmaiVc42VzdA0zZLM81jCK1y2m2iNfLQ=";
      homepage = "https://freepats.zenvoid.org/ChromaticPercussion/tubular-bells.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "xylophone";
      fname = "Xylophone-MediumMallets";
      version = "2020-07-06";
      url = "https://freepats.zenvoid.org/ChromaticPercussion/Xylophone1/Xylophone-MediumMallets-SFZ+FLAC-20200706.tar.gz";
      sha256 = "sha256-pk9nSkYM+BGcF3Ym9B7nL3YukxTggjgWAeE8Lq2krMA=";
      homepage = "https://freepats.zenvoid.org/ChromaticPercussion/xylophone.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "church-organ-emulation";
      fname = "ChurchOrganEmulation";
      version = "2019-09-24";
      url = "https://freepats.zenvoid.org/Organ/ChurchOrganEmulation/ChurchOrganEmulation-SFZ-20190924.tar.xz";
      sha256 = "sha256-HwtwosKvFM3wUe8tJWs7tlLn1kwP3IvtBmQq0q+Rbbk=";
      homepage = "https://freepats.zenvoid.org/Organ/pipe-organ.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "drawbar-organ-emulation";
      fname = "DrawbarOrganEmulation";
      version = "2019-07-12";
      url = "https://freepats.zenvoid.org/Organ/DrawbarOrganEmulation/DrawbarOrganEmulation-SFZ-20190712.tar.xz";
      sha256 = "sha256-4toYsKTRO+cCADfhjkpxk4dDM1fnYD0Hc5kOeU3PXQ8=";
      homepage = "https://freepats.zenvoid.org/Organ/electric-organ.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "percussive-organ-emulation";
      fname = "PercussiveOrganEmulation";
      version = "2019-07-15";
      url = "https://freepats.zenvoid.org/Organ/PercussiveOrganEmulation/PercussiveOrganEmulation-SFZ-20190715.tar.xz";
      sha256 = "sha256-xIQfLn81JpLPFKhalr0fQKnqep4qnONRJgaIXQAJeMg=";
      homepage = "https://freepats.zenvoid.org/Organ/electric-organ.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "rock-organ-emulation";
      fname = "RockOrganEmulation";
      version = "2019-07-15";
      url = "https://freepats.zenvoid.org/Organ/RockOrganEmulation/RockOrganEmulation-SFZ-20190715.tar.xz";
      sha256 = "sha256-BzIdlJjcMZgsROqUg5Gd8/Qm49OSoVuylHsOP+JH9xg=";
      homepage = "https://freepats.zenvoid.org/Organ/electric-organ.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "button-accordian-hn";
      fname = "ButtonAccordianHN";
      version = "2024-03-29";
      url = "https://github.com/freepats/button-accordion-HN/releases/download/2024-03-29/ButtonAccordionHN-SFZ+FLAC-20240329.7z";
      sha256 = "sha256-5TJqiDDwNY+qGVYJ/SHQwduriZ45vX9EsVkOvyzlA14=";
      homepage = "https://freepats.zenvoid.org/Organ/accordion.html";
      license = lib.licenses.cc0;
    }
  ]

/*
  [
    stdenv.mkDerivation {
      pname = "freepats-upright-piano-kw";
      version = "unstable-2022-02-21";

      src = fetchurl {
        url = "https://freepats.zenvoid.org/Piano/UprightPianoKW/UprightPianoKW-SF2-20220221.7z";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 UprightPianoKW-*.sf2 $out/share/soundfonts/UprightPianoKW.sf2
      '';

      meta = with lib; {
        description = "Acoustic Kawai upright piano sf2 soundfont";
        homepage = "https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepats-ydp-grand-piano";
      version = "unstable-2016-08-04";

      src = fetchurl {
        url = "https://freepats.zenvoid.org/Piano/YDP-GrandPiano/YDP-GrandPiano-SF2-20160804.tar.bz2";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 YDP-GrandPiano-*.sf2 $out/share/soundfonts/YDP-GrandPiano.sf2
      '';

      meta = with lib; {
        description = "Acoustic grand piano sf2 soundfont";
        homepage = "https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html";
        license = licenses.cc-by-30;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepats-salamander-grand-piano";
      version = "unstable-2020-06-02";

      src = fetchurl {
        url = "https://freepats.zenvoid.org/Piano/SalamanderGrandPiano/SalamanderGrandPiano-SF2-V3+20200602.tar.xz";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 SalamanderGrandPiano-*.sf2 $out/share/soundfonts/SalamanderGrandPiano.sf2
      '';

      meta = with lib; {
        description = "Acoustic Yamaha C5 sf2 soundfont";
        homepage = "https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html";
        license = licenses.cc-by-30;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepats-old-piano-fb";
      version = "unstable-2020-04-01";

      src = fetchurl {
        url = "https://github.com/freepats/old-piano-FB/releases/download/2020-04-01/PianoFB-SF2-20200401.7z";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 PianoFB-*.sf2 $out/share/soundfonts/PianoFB.sf2
      '';

      meta = with lib; {
        description = "Francis Bacon player piano (Honky-tonk) sf2 soundfont";
        homepage = "https://freepats.zenvoid.org/Piano/honky-tonk-piano.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepats-fm-piano1";
      version = "unstable-2020-04-01";

      src = fetchurl {
        url = "https://github.com/freepats/fm-piano1/releases/download/2019-09-16/FM-Piano1-SF2-20190916.7z";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 FM-Piano1-*.sf2 $out/share/soundfonts/FM-Piano1.sf2
      '';

      meta = with lib; {
        description = "Imitation of Yamaha DX7 electric piano sf2 soundfont";
        homepage = "https://freepats.zenvoid.org/ElectricPiano/synthesized-piano.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepats-fm-piano2";
      version = "unstable-2016-11-12";

      src = fetchurl {
        url = "https://github.com/freepats/fm-piano2/releases/download/2016-11-12/FM-Piano2-SF2-20161112.7z";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 FM-Piano2-*.sf2 $out/share/soundfonts/FM-Piano2.sf2
      '';

      meta = with lib; {
        description = "Imitation of Yamaha DX7 electric piano sf2 soundfont";
        homepage = "https://freepats.zenvoid.org/ElectricPiano/synthesized-piano.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepat-glass";
      version = "unstable-2019-12-27";

      src = fetchurl {
        url = "https://freepats.zenvoid.org/ChromaticPercussion/Glass/Glass-SFZ+FLAC-20191227.7z";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 Glass-*.sfz $out/share/soundfonts/Glass/Glass.sfz
        install -Dm644 samples $out/share/soundfonts/Glass/samples
      '';

      meta = with lib; {
        description = "Glasses of water sfz soundfont";
        homepage = "https://freepats.zenvoid.org/ChromaticPercussion/glass.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepat-hang";
      version = "unstable-2022-03-30";

      src = fetchurl {
        url = "https://github.com/freepats/hang-D-minor/releases/download/2022-03-30/Hang-D-minor-SFZ+FLAC-20220330.7z";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 Hang-D-minor-*.sfz $out/share/soundfonts/Hang-D-minor/Hang-D-minor.sfz
        install -Dm644 samples $out/share/soundfonts/Hang-D-minor/samples
      '';

      meta = with lib; {
        description = "Hang (tuned in D minor) sfz soundfont";
        homepage = "https://freepats.zenvoid.org/ChromaticPercussion/hang.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepat-tubular-bells";
      version = "unstable-2020-07-29";

      src = fetchurl {
        url = "https://freepats.zenvoid.org/ChromaticPercussion/TubularBells/TubularBells-SFZ+FLAC-20200729.tar.gz";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 TubularBells-*.sfz $out/share/soundfonts/TubularBells/TubularBells.sfz
        install -Dm644 samples $out/share/soundfonts/TubularBells/samples
      '';

      meta = with lib; {
        description = "Tubular bells sfz soundfont";
        homepage = "https://freepats.zenvoid.org/ChromaticPercussion/tubular-bells.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
    stdenv.mkDerivation {
      pname = "freepat-tubular-bells";
      version = "unstable-2020-07-29";

      src = fetchurl {
        url = "https://freepats.zenvoid.org/ChromaticPercussion/TubularBells/TubularBells-SFZ+FLAC-20200729.tar.gz";
        sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
      };

      installPhase = ''
        install -Dm644 TubularBells-*.sfz $out/share/soundfonts/TubularBells/TubularBells.sfz
        install -Dm644 samples $out/share/soundfonts/TubularBells/samples
      '';

      meta = with lib; {
        description = "Tubular bells sfz soundfont";
        homepage = "https://freepats.zenvoid.org/ChromaticPercussion/tubular-bells.html";
        license = licenses.cc0;
        platforms = platforms.all;
      };
    }
  ]
  */