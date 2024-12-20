resource "checkpoint_management_administrator" "admin" { 
  name = "tfroadmin"
  permissions_profile {
   domain = "SMC User"
   profile = "Read Only All"
}
password = "vpn123"
}