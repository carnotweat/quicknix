{
  nix = {
      extraOptions = ''
      substituters = [
        "https://3mdeb.cachix.org"
      ];
      trusted-public-keys = [
        "3mdeb.cachix.org-1:PT8REwCzIh32OHNtN8WITXBvp3Xsdci2SY7eUqfEnDc="
      ];
   ''; 
  };
}
