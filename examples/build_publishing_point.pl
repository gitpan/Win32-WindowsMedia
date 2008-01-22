#!/usr/bin/perl

use strict;
use Win32::WindowsMedia;

my $main =new Win32::WindowsMedia;
my $provisioner =new Win32::WindowsMedia::Provision;
my $information =new Win32::WindowsMedia::Information;
my $controller =new Win32::WindowsMedia::Control;

# Build a Server Object Instance
my $server_object = $main->Server_Create("127.0.0.1");

# Build a new publishing point , push, called 'andrew'
my $publishing_point = $provisioner->
		Publishing_Point_Create( 
			$server_object, 
			"andrew",
			"push:*",
			"broadcast"
			);

#$publishing_point = $provisioner-> 
#		Publishing_Point_Start(
#			$server_object,
#			"andrew"
#			);
#
#$publishing_point = $provisioner-> 
#		Publishing_Point_Stop(
#			$server_object,
#			"andrew"
#			);
#
my %publishing_point_limits;

$publishing_point = $provisioner->
		Publishing_Point_Limits_Get(
			$server_object,
			"andrew",
			\%publishing_point_limits
			);
foreach my $limit ( keys %publishing_point_limits )
	{
	print "Key is '$limit' value is '$publishing_point_limits{$limit}'\n";
	}

