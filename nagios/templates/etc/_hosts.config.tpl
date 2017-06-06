
{{- range .Values.conf.hosts }}
define host  {
 {{- range $key, $val := . }}
 {{ $key }}  {{ $val | indent 4 }}
 {{- end }}
  hostgroups compute_nodes
  max_check_attempts 5
  check_command check-host-alive
}

{{- end }}
#######################################################################################
define hostgroup{
        hostgroup_name  compute_nodes
        alias           compute_nodes
        members         VLCP-1,VLCP-2
        }

#############################################
# Define a service to "ping" the local machine
define service{
        use                             local-service,graphed-service         ; Name of service template to use
        hostgroup_name                  compute_nodes
        service_description             PING
        check_command                   check_ping!100.0,20%!500.0,60%
        }

# Define a service to check the disk space of the root partition
# on the local machine.  Warning if < 20% free, critical if
# < 10% free space on partition.
define service{
        use                             local-service,graphed-service         ; Name of service template to use
        hostgroup_name                  compute_nodes
        service_description             Root Partition
        check_command                   check_local_disk!20%!10%!/
        }

# Define a service to check the number of currently logged in
# users on the local machine.  Warning if > 20 users, critical
# if > 50 users.
define service{
        use                             local-service,graphed-service         ; Name of service template to use
        hostgroup_name                  compute_nodes
        service_description             Current Users
        check_command                   check_local_users!20!50
        }

# Define a service to check the number of currently running procs
# on the local machine.  Warning if > 250 processes, critical if
# > 400 users.
define service{
        use                             local-service,graphed-service         ; Name of service template to use
        hostgroup_name                  compute_nodes
        service_description             Total Processes
        check_command                   check_local_procs!250!400!RSZDT
        }

# Define a service to check the load on the local machine.
define service{
        use                             local-service,graphed-service         ; Name of service template to use
        hostgroup_name                  compute_nodes
        service_description             Current Load
        check_command                   check_local_load!5.0,4.0,3.0!10.0,6.0,4.0
        }

# Define a service to check the swap usage the local machine.
# Critical if less than 10% of swap is free, warning if less than 20% is free
define service{
        use                             local-service,graphed-service         ; Name of service template to use
        hostgroup_name                  compute_nodes
        service_description             Swap Usage
        check_command                   check_local_swap!20!10
        }

# Define a service to check HTTP on the local machine.
# Disable notifications for this service by default, as not all users may have HTTP enabled.
define service{
        use                             local-service,graphed-service         ; Name of service template to use
        hostgroup_name                  compute_nodes
        service_description             HTTP
        check_command                   check_http
        notifications_enabled           0
        }

