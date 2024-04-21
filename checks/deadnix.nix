
pkgs:
{
  packages = [ pkgs.deadnix ];
  machine-readable = "deadnix --fail --output-format json";
  human-readable = "deadnix --fail";
  to-github-annotations = "echo $in";
}