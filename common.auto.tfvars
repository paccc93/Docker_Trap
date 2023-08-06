security_groups = [
  # {    
  #   from_port   = 22
  #   name        = "SSH port"
  #   protocol    = "tcp"
  #   to_port     = 22
  #   cidr_blocks = ["0.0.0.0/0"] # you can replace with your office wifi outbount IP range
  # },
  
  {
    from_port   = 80
    name        = "NGINX Port"
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
]
