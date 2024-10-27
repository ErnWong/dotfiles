{
  lib,
  stdenv,
  fetchurl,
  p7zip,
}:
map
  (
    {
      pname,
      version,
      fname,
      license,
      url,
      sha256,
      homepage,
    }:
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

      phases = [
        "unpackPhase"
        "installPhase"
      ];

      meta = with lib; {
        inherit license homepage;
        platforms = platforms.all;
      };
    }
  )
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
    {
      pname = "spanish-classical-guitar";
      fname = "SpanishClassicalGuitar";
      version = "2019-06-18";
      url = "https://freepats.zenvoid.org/Guitar/SpanishClassicalGuitar/SpanishClassicalGuitar-SFZ+FLAC-20190618.7z";
      sha256 = "sha256-kDkWkhohZi0iN63n8OmOVd6Ty3uG2iGeThD0rThbj14=";
      homepage = "https://freepats.zenvoid.org/Guitar/acoustic-guitar.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "fss-steel-string-guitar";
      fname = "FSS-SteelStringGuitar";
      version = "2020-05-21";
      url = "https://freepats.zenvoid.org/Guitar/FSS-SteelStringGuitar/FSS-SteelStringGuitar-SFZ-20200521.tar.xz";
      sha256 = "sha256-cgtVxa1Nz7n3iKsToL2oNMv9ezIU3yypBkjFiVHkF3c=";
      homepage = "https://freepats.zenvoid.org/Guitar/steel-acoustic-guitar.html";
      license = {
        fullName = "GNU General Public License version 3 or later, with a special exception.";
        url = "https://freepats.zenvoid.org/licenses.html#GPL_exception";
      };
    }
    {
      pname = "eguitar-fsbs-bridge-clean";
      fname = "EGuitarFSBS-bridge-clean";
      version = "2022-09-11";
      url = "https://freepats.zenvoid.org/ElectricGuitar/FSBS-EGuitar/EGuitarFSBS-bridge-clean-SFZ+FLAC-20220911.7z";
      sha256 = "sha256-03FJa9sGIkROiVamXoWVMlfvnq6bt8tuZ1US5h3qwXs=";
      homepage = "https://freepats.zenvoid.org/ElectricGuitar/clean-electric-guitar.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "eguitar-fsbs-bridge-jazz";
      fname = "EGuitarFSBS-bridge-jazz";
      version = "2022-09-11";
      url = "https://freepats.zenvoid.org/ElectricGuitar/FSBS-EGuitar/EGuitarFSBS-bridge-jazz-SFZ+FLAC-20220911.7z";
      sha256 = "sha256-PTtRGPHbHHE0qKcvjtAoys6S9FQMH/ptpNsPEaMUzs0=";
      homepage = "https://freepats.zenvoid.org/ElectricGuitar/clean-electric-guitar.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "eguitar-fsbs-bridge-direct";
      fname = "EGuitarFSBS-bridge-direct";
      version = "2022-09-11";
      url = "https://freepats.zenvoid.org/ElectricGuitar/FSBS-EGuitar/EGuitarFSBS-bridge-direct-SFZ+FLAC-20220911.7z";
      sha256 = "sha256-5+e1q/7aih6opxhqjco07VxsRQKk6bPp5nB1Pk8OuZA=";
      homepage = "https://freepats.zenvoid.org/ElectricGuitar/clean-electric-guitar.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "eguitar-fsbs-bridge-dist1";
      fname = "EGuitarFSBS-bridge-dist1";
      version = "2022-09-11";
      url = "https://freepats.zenvoid.org/ElectricGuitar/FSBS-EGuitar/EGuitarFSBS-bridge-dist1-SFZ+FLAC-20220911.7z";
      sha256 = "sha256-kXRsjOMuH+6a8GGFA/g82AXTY4wYDqxSGBD3SH8RUYU=";
      homepage = "https://freepats.zenvoid.org/ElectricGuitar/distorted-electric-guitar.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "eguitar-fsbs-bridge-dist2";
      fname = "EGuitarFSBS-bridge-dist2";
      version = "2022-09-11";
      url = "https://freepats.zenvoid.org/ElectricGuitar/FSBS-EGuitar/EGuitarFSBS-bridge-dist2-SFZ+FLAC-20220911.7z";
      sha256 = "sha256-3CxQ3p8kdcgavCIzphQGo9exb4/CBNv5p/qTHv13j6A=";
      homepage = "https://freepats.zenvoid.org/ElectricGuitar/distorted-electric-guitar.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "picked-bass-yamaha-rbx";
      fname = "PickedBassYR";
      version = "2019-09-30";
      url = "https://github.com/freepats/electric-bass-YR/releases/download/2019-09-30/PickedBassYR-SFZ+FLAC-20190930.7z";
      sha256 = "sha256-qnZQ/CBqftg+yvo2okVy4fTqBBk4GCuYG/ERuZ4bjoU=";
      homepage = "https://freepats.zenvoid.org/ElectricGuitar/clean-electric-bass.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "concert-harp";
      fname = "ConcertHarp";
      version = "2020-07-02";
      url = "https://freepats.zenvoid.org/OrchestralStrings/ConcertHarp/ConcertHarp-SFZ+FLAC-20200702.tar.gz";
      sha256 = "sha256-fTp35OlQHXM6Ayy32TvHVn9H5AeDJTKO/ntF+wOsSK0=";
      homepage = "https://freepats.zenvoid.org/OrchestralStrings/harp.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "clarinet";
      fname = "Clarinet";
      version = "2019-08-18";
      url = "https://freepats.zenvoid.org/Reed/Clarinet1/Clarinet-SFZ-20190818.tar.xz";
      sha256 = "sha256-SB/WiPAD/Ekw5JEjGZ/YjnQwN2y4Dz7PpoXX9hDSCpg=";
      homepage = "https://freepats.zenvoid.org/Reed/clarinet.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "tenor-saxophone";
      fname = "TenorSaxophone";
      version = "2019-08-18";
      url = "https://freepats.zenvoid.org/Reed/TenorSaxophone/TenorSaxophone-SFZ-20200717.tar.xz";
      sha256 = "sha256-nufuH1TF+VJve5NJ+I5fbq3FgsKyzK7bRYnown8MfT4=";
      homepage = "https://freepats.zenvoid.org/Reed/saxophone.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "recorder";
      fname = "Recorder";
      version = "2020-12-05";
      url = "https://freepats.zenvoid.org/Wind/Recorder1/Recorder-SFZ+FLAC-20201205.7z";
      sha256 = "sha256-hxkQr+hD+QtgSstqzKmWl6/QET1MsIcak8dmDOurMPE=";
      homepage = "https://freepats.zenvoid.org/Wind/recorder.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "ocarina";
      fname = "Ocarina";
      version = "2024-10-02";
      url = "https://github.com/freepats/ocarina1/releases/download/2024-10-02/Ocarina-SFZ+FLAC-20241002.7z";
      sha256 = "sha256-5w/wkEtgWjnI1iC9u1SXqYjX17NjOND7eW5aJC+zNSE=";
      homepage = "https://freepats.zenvoid.org/Wind/ocarina.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "lately-bass";
      fname = "LatelyBass";
      version = "2024-04-09";
      url = "https://github.com/freepats/lately-bass/releases/download/2024-04-09/LatelyBass-SFZ+FLAC-20240409.7z";
      sha256 = "sha256-PLbUCBs5zqJlARoh8FpCT8coRav9F9dAmsFqzHEio+A=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-bass.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-bass-1";
      fname = "SynthBass1";
      version = "2019-07-23";
      url = "https://github.com/freepats/synth-bass-1/releases/download/2019-07-23/SynthBass1-SFZ+FLAC-20190723.7z";
      sha256 = "sha256-s5iKeChikiANf6jSu+cIqAuwKyjVGfin0MZt9+iU8Hs=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-bass.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-bass-2";
      fname = "SynthBass2";
      version = "2019-04-05";
      url = "https://github.com/freepats/synth-bass-2/releases/download/2021-04-05/SynthBass2-SFZ+FLAC-20210405.7z";
      sha256 = "sha256-OgT8coGXt0bV6Cpc7Se93Ff1LbXlu1QmoH7xR3Gy7k8=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-bass.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-strings-1";
      fname = "SynthStrings1";
      version = "2020-05-28";
      url = "https://github.com/freepats/synth-strings-1/releases/download/2020-05-28/SynthStrings1-SFZ+FLAC-20200528.7z";
      sha256 = "sha256-BJemAYOoba7WXCc9weVkjyl7BnFBCKaqYxEfl5BZlBg=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-strings.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-strings-2";
      fname = "SynthStrings2";
      version = "2020-05-28";
      url = "https://github.com/freepats/synth-strings-2/releases/download/2020-05-28/SynthStrings2-SFZ+FLAC-20200528.7z";
      sha256 = "sha256-zuxZZjFNntfb0LqDhQ1VNwlsjqsSdCKIDciBV2be18I=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-strings.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-brass-1";
      fname = "SynthBrass1";
      version = "2021-04-26";
      url = "https://github.com/freepats/synth-brass-1/releases/download/2021-04-26/SynthBrass1-SFZ+FLAC-20210426.7z";
      sha256 = "sha256-aPieokpn4M5NtQVJdBz3I/9PqPj4tBg04EsXTjVxJOE=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-brass.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-brass-2";
      fname = "SynthBrass2";
      version = "2021-06-10";
      url = "https://github.com/freepats/synth-brass-2/releases/download/2024-06-10/SynthBrass2-SFZ+FLAC-20240610.7z";
      sha256 = "sha256-q+p9FRD0YAE0nr7IG1oyPOEgItH0lgTQB0WXulXUeHg=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-brass.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-bass-lead";
      fname = "SynthBassLead";
      version = "2020-05-22";
      url = "https://github.com/freepats/synth-bass-lead/releases/download/2020-05-22/SynthBassLead-SFZ+FLAC-20200522.7z";
      sha256 = "sha256-n9PBE6SZAtZEFnGT9CHhD7DEo10gzap9jY0a69/QDo0=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-lead.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-fifths";
      fname = "SynthFifths";
      version = "2020-05-19";
      url = "https://github.com/freepats/synth-fifths/releases/download/2020-05-19/SynthFifths-SFZ+FLAC-20200519.7z";
      sha256 = "sha256-iRZglkpEUNMtVLG5avgASypkYny5ZZj9nhfSFSvlOxA=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-lead.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-square";
      fname = "SynthSquare";
      version = "2020-05-12";
      url = "https://github.com/freepats/synth-square/releases/download/2020-05-12/SynthSquare-SFZ+FLAC-20200512.7z";
      sha256 = "sha256-DZ+6SFs/VC03MKJC8hMXT+vHkVmP1i3a0UTAXVu4qkw=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-lead.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-calliope";
      fname = "SynthCalliope";
      version = "2020-05-12";
      url = "https://github.com/freepats/synth-calliope/releases/download/2020-05-12/SynthCalliope-SFZ+FLAC-20200512.7z";
      sha256 = "sha256-0vze6QDPDhk3kYDnChyGxnD99AbYtPCZxgHjrOKTgkY=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-lead.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-pad-choir";
      fname = "SynthPadChoir";
      version = "2020-05-16";
      url = "https://github.com/freepats/synth-pad-choir/releases/download/2020-05-16/SynthPadChoir-SFZ+FLAC-20200516.7z";
      sha256 = "sha256-cD7zD61IYfhbMZ+NVJ++6wrwhgkpFlxwZkENy7A9oKM=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-pad.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "sweep-pad";
      fname = "SweepPad";
      version = "2019-08-13";
      url = "https://github.com/freepats/sweep-pad/releases/download/2019-08-13/SweepPad-SFZ+FLAC-20190813.7z";
      sha256 = "sha256-sLPzNN2J2QUHFC2nbxKabkM2ndqSwaAvT833rxOwXUk=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-pad.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "new-age";
      fname = "NewAge";
      version = "2019-07-30";
      url = "https://github.com/freepats/new-age/releases/download/2019-07-30/NewAge-SFZ+FLAC-20190730.7z";
      sha256 = "sha256-NVxobuyqxNmFeors+ZYu7nu21pvUjFVgj0cYXaY/XZ4=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-pad.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-pad-bowed";
      fname = "SynthPadBowed";
      version = "2019-07-19";
      url = "https://github.com/freepats/synth-pad-bowed/releases/download/2019-07-19/SynthPadBowed-SFZ+FLAC-20190719.7z";
      sha256 = "sha256-bnRphtPb3N3S9M5xGIL94foW3lpZkCs67FMDAigbMow=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-pad.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-goblins";
      fname = "SynthGoblins";
      version = "2020-06-12";
      url = "https://github.com/freepats/synth-goblins/releases/download/2020-06-12/SynthGoblins-SFZ+FLAC-20200612.7z";
      sha256 = "sha256-9VorGjPVZG47ZB1DyyQ4I5VWrhXXk+vAypqgocGbdZg=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-effects.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-soundtrack";
      fname = "SynthSoundtrack";
      version = "2020-05-21";
      url = "https://github.com/freepats/synth-soundtrack/releases/download/20200521/SynthSoundtrack-SFZ+FLAC-20200521.7z";
      sha256 = "sha256-Xu5oQ8P4OqtV0kR23wh9ySxtI+8jpFcNCvkDceB9GP4=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-effects.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-sci-fi";
      fname = "SynthSciFi";
      version = "2020-05-17";
      url = "https://github.com/freepats/synth-scifi/releases/download/2020-05-17/SynthSciFi-SFZ+FLAC-20200517.7z";
      sha256 = "sha256-geKSTCHsp4ArAH9YtJJYuWRdnsPULfxIFSKCBjsat2w=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-effects.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synth-crystal";
      fname = "SynthCrystal";
      version = "2019-08-12";
      url = "https://github.com/freepats/synth-crystal/releases/download/2019-08-12/SynthCrystal-SFZ+FLAC-20190812.7z";
      sha256 = "sha256-84oQJZMbvoy8ZNLM+20TQnkMwk/OD1Y0EV7DCKD5C4s=";
      homepage = "https://freepats.zenvoid.org/Synthesizer/synth-effects.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "bagpipe";
      fname = "Bagpipe";
      version = "2022-12-04";
      url = "https://freepats.zenvoid.org/Ethnic/Bagpipe/Bagpipe-SFZ+FLAC-20221204.7z";
      sha256 = "sha256-zo0Tsb206eR6tgPh6sZcI/AGXmdZ/0BFsa1bqEcENzQ=";
      homepage = "https://freepats.zenvoid.org/Ethnic/bagpipe.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "kalimba";
      fname = "Kalimba";
      version = "2019-07-23";
      url = "https://freepats.zenvoid.org/Ethnic/Kalimba/Kalimba-SFZ-20190723.tar.xz";
      sha256 = "sha256-4mpzRsN4SfVx0oy5fs6OHjK4vN35OGYpTR1B+lUBR4I=";
      homepage = "https://freepats.zenvoid.org/Ethnic/kalimba.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "jaw-harp";
      fname = "JawHarp";
      version = "2020-06-06";
      url = "https://freepats.zenvoid.org/Ethnic/JawHarp/JawHarp-SFZ-20200606.tar.bz2";
      sha256 = "sha256-j2Ncm/J5d0zTTdWjNrY6bmUgFfNRQlP3vlNGfWfluQw=";
      homepage = "https://freepats.zenvoid.org/Ethnic/jaw-harp.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "muldjord-kit";
      fname = "MuldjordKit";
      version = "2020-10-18";
      url = "https://github.com/freepats/muldjordkit/releases/download/2020-10-18/MuldjordKit-SFZ+FLAC-20201018.7z";
      sha256 = "sha256-iSYQBilqmk2T39osHFo5JSFeJDKfQIwsi8G89uoSPI8=";
      homepage = "https://freepats.zenvoid.org/Percussion/acoustic-drum-kit.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "timpani";
      fname = "Timpani";
      version = "2024-08-10";
      url = "https://github.com/freepats/timpani/releases/download/2024-08-10/Timpani-SFZ+FLAC-20240810.7z";
      sha256 = "sha256-yIOw25FSMrSBVBjpxrGMW07XP599hN4+wleF8YuNq4U=";
      homepage = "https://freepats.zenvoid.org/Percussion/orchestral-percussion.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "synthesizer-percussion";
      fname = "SynthesizerPercussion";
      version = "2022-07-18";
      url = "https://freepats.zenvoid.org/Percussion/SynthesizerPercussion/SynthesizerPercussion-SFZ-20220718.7z";
      sha256 = "sha256-27Llu4JoAi//ptzD0RqTNoMWA4vzroGpZcWOnUkO0js=";
      homepage = "https://freepats.zenvoid.org/Percussion/electric-percussion.html";
      license = lib.licenses.cc0;
    }
    {
      pname = "world-percussion";
      fname = "WorldPercussion";
      version = "2020-09-05";
      url = "https://github.com/freepats/world-percussion/releases/download/2020-09-05/WorldPercussion-SFZ+FLAC-20200905.7z";
      sha256 = "sha256-bhA1ONxymlISKRHZ7RAGp+FW5izBL5Fqkf4Y5biR0vY=";
      homepage = "https://freepats.zenvoid.org/Percussion/world-and-rare-percussion.html";
      license = lib.licenses.cc0;
    }
  ]
