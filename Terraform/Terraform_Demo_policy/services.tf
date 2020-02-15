resource "checkpoint_management_service_tcp" "service1" {
  name = "service1"
  port = 50001
  color = "blue"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_tcp" "service2" {
  name = "service2"
  port = 50002
  color = "red"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_tcp" "service3" {
  name = "service3"
  port = 50003
  color = "sea green"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_tcp" "service4" {
  name = "service4"
  port = 51004
  color = "pink"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_tcp" "service5" {
  name = "service5"
  port = 50004
  color = "orange"
  match_for_any = false
  session_timeout = 3550
}

resource "checkpoint_management_service_udp" "service1" {
  name = "UDP_service1"
  port = 50001
  color = "blue"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_udp" "service2" {
  name = "UDP_service2"
  port = 50002
  color = "red"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_udp" "service3" {
  name = "UDP_service3"
  port = 50003
  color = "sea green"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_udp" "service4" {
  name = "UDP_service4"
  port = 51004
  color = "pink"
  match_for_any = false
  session_timeout = 3550
}
resource "checkpoint_management_service_udp" "service5" {
  name = "UDP_service5"
  port = 50004
  color = "orange"
  match_for_any = false
  session_timeout = 3550
}
