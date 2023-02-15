output "astro_dev_instance_id" {
  value = aws_instance.astro-dev.id
}

output "astro_public_ip" {
  value = aws_instance.astro-dev.public_ip
}

output "astro_url" {
  value = "https://${aws_instance.astro-dev.public_ip}/"
}

output "ssh_cmd" {
  value = "ssh -l ubuntu ${aws_instance.astro-dev.public_ip}"
}

output "tail_cloudinit_cmd" {
  value = "ssh -o StrictHostKeyChecking=accept-new -l ubuntu ${aws_instance.astro-dev.public_ip} sudo tail -f /var/log/cloud*"
}