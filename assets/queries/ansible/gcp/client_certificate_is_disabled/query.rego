package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster, "master_auth", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_container_cluster}}.master_auth is defined",
		"keyActualValue": "{{google.cloud.gcp_container_cluster}}.master_auth is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	object.get(cluster.master_auth, "client_certificate_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.client_certificate_config is defined",
		"keyActualValue": "google.cloud.gcp_container_cluster.master_auth.client_certificate_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cluster := task["google.cloud.gcp_container_cluster"]

	ansLib.checkState(cluster)
	ansLib.isAnsibleFalse(cluster.master_auth.client_certificate_config.issue_client_certificate)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_container_cluster}}.master_auth.client_certificate_config.issue_client_certificate", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google.cloud.gcp_container_cluster.master_auth.password is true",
		"keyActualValue": "google.cloud.gcp_container_cluster.master_auth.password is false",
	}
}
