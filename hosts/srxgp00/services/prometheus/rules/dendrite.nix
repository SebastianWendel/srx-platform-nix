{
  dendrite_up = {
    condition = "dendrite_up != 1";
    description = "Dendrite on {{$labels.instance}} seems to be down!";
  };
}
