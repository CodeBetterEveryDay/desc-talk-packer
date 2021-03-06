# DSEC AWS Workshop

# ================================================================================
# 1. VARIABLES
# ================================================================================

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}

# ================================================================================
# 2. PROVIDERS
# ================================================================================

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-1"
}

# ================================================================================
# 3. RESOURCES
# ================================================================================

resource "aws_instance" "webserver" {
  ami           = "ami-047bb4163c506cd98"
  instance_type = "t1.micro"
  key_name        = "${var.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "echo '<html><head><title>WebSrv1</title></head><body>DSEC Workshop</p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }

  tags {
    Name = "WEB-1",
    Team = "DSEC-Workshop",
    Role = "WebServer",
  }
}

# ================================================================================
# 4. OUTPUT
# ================================================================================

output "aws_instance_public_dns" {
    value = "${aws_instance.webserver.public_dns}"
}
