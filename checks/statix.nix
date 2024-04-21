pkgs:
{
  packages = [ pkgs.statix ];
  machine-readable = "statix check . --format json";
  human-readable = "statix check .";
  to-github-annotations = "echo $in";
}