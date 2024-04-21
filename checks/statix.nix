pkgs:
{
  packages = [ pkgs.statix ];
  machine-readable = "statix check . --format json";
  human-readable = "statix check .";
  to-github-annotations = ''
    split row --regex "\n}"
    | drop 1
    | each {|file_string|
      let file = $"($file_string)}"
      | from json

      $file | $in.report
      | each {|report|
        let level = match $report.severity {
          'Hint' => 'notice'
          'Warn' => 'warning'
          'Error' => 'error'
        }
        $report.diagnostics | each {|diagnostic|
          $"::($level) file=($file.file),line=($diagnostic.at.from.line),endline=($diagnostic.at.to.line),title=($report.note)::($diagnostic.message)"
        }
        | str join "\n"
      }
      | str join "\n"
    }
    | str join "\n"
  '';
}