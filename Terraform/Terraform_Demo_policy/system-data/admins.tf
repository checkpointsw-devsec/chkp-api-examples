resource "checkpoint_management_administrator" "admin" { 
  name = "roadmin"
  permissions_profile {
   domain = "SMC User"
   profile = "Read Only All"
}
password = "vpnl23"
}