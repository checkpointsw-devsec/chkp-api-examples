resource "checkpoint_management_host" "host1" {
  name = "host1"
  ipv4_address = "1.2.3.4"
  color = "blue"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "host2" {
  name = "host2"
  ipv4_address = "2.3.3.4"
  color = "red"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "host3" {
  name = "host3"
  ipv4_address = "3.2.3.4"
  color = "sea green"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "host4" {
  name = "host4"
  ipv4_address = "4.2.3.4"
  color = "pink"
  nat_settings = {
    auto_rule = false
    }
}

resource "checkpoint_management_host" "host5" {
  name = "host5"
  ipv4_address = "5.2.3.4"
  color = "orange"
  nat_settings = {
    auto_rule = false
    }
}

