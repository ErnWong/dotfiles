
pkgs:
{
  packages = [ pkgs.deadnix ];
  machine-readable = "deadnix --fail --output-format json";
  human-readable = "deadnix --fail";
  to-github-annotations = ''
    from json --objects
    | each {|file|
      $file.results | each {|result|
          $"::warning file=($file.file),line=($result.line),endline=($result.line)::($result.message)"
      }
      | str join "\n"
    }
    | str join "\n"
  '';
}