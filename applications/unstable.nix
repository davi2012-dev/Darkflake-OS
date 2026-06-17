{ unstable, ... }:

{
  environment.systemPackages = with unstable;
    unstable.librewolf
  ];
}
