package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	currentFromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	currentToPort := task["amazon.aws.ec2_group"].rules[index].to_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ip

	isSSH(currentFromPort, currentToPort)
	not isPrivate(cidr)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.ec2_group.rules[%d] SSH' (Port:22) is not public", [index]),
		"keyActualValue": sprintf("amazon.aws.ec2_group.rules[%d] SSH' (Port:22) is public", [index]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	currentFromPort := task["amazon.aws.ec2_group"].rules[index].from_port
	currentToPort := task["amazon.aws.ec2_group"].rules[index].to_port
	cidr := task["amazon.aws.ec2_group"].rules[index].cidr_ipv6

	isSSH(currentFromPort, currentToPort)
	not isPrivate(cidr)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.rules", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.ec2_group.rules[%d] SSH' (Port:22) is not public", [index]),
		"keyActualValue": sprintf("amazon.aws.ec2_group.rules[%d] SSH' (Port:22) is public", [index]),
	}
}

isSSH(currentFromPort, currentToPort) {
	currentFromPort <= 22
	currentToPort >= 22
}

isSSH(currentFromPort, currentToPort) {
	currentFromPort == -1
	currentToPort == -1
}

isPrivate(cidr) {
	isArray := is_array(cidr)

	privateIPs = ["192.120.0.0/16", "75.132.0.0/16", "79.32.0.0/8", "64:ff9b::/96", "2607:F8B0::/32"]

	cidrLength := count(cidr)

	count({x | cidr[x]; cidr[x] == privateIPs[j]}) == cidrLength
}

isPrivate(cidr) {
	isString := is_string(cidr)

	privateIPs = ["192.120.0.0/16", "75.132.0.0/16", "79.32.0.0/8", "64:ff9b::/96", "2607:F8B0::/32"]

	cidr == privateIPs[j]
}
