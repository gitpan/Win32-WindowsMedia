package Win32::WindowsMedia::Provision;

use warnings;
use strict;
#use Win32::OLE qw( in with HRESULT );
#use Win32::OLE::Const "Windows Media Services Server Object Model and Plugin 9.0 Type Library";

=head1 NAME

Win32::WindowsMedia::Provision - The provisioning module for WindowsMedia

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Win32::WindowsMedia::Provision;

=head1 FUNCTIONS

=head2 Publishing_Point_Authorization_ACL_Add

=head2 Publishing_Point_Authorization_ACL_Remove

=head2 Publishing_Point_Authorization_IPAddress_Add

=head2 Publishing_Point_Authorization_IPAddress_Remove 

=head2 Publishing_Point_General_Set

=head2 Publishing_Point_General_Get

=head2 Publishing_Point_Limits_Set

=head2 Publishing_Point_Limits_Get

=head2 Publishing_Point_Start

=head2 Publishing_Point_Stop

=head2 Publishing_Point_Remove

=head2 Publishing_Point_Create

=cut

sub new {

        my $self = {};
        bless $self;

        my ( $class , $attr ) =@_;

        while (my($field, $val) = splice(@{$attr}, 0, 2))
                { $self->{_GLOBAL}{$field}=$val; }

        $self->{_GLOBAL}{'STATUS'}="OK";

        return $self;
}

sub Publishing_Point_Authorization_ACL_Add
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $limit_parameters = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $limit_variables = Win32::WindowsMedia::BaseVariables->UserAccessSettings();
my $User_Control = $publishing_point->EventHandlers("WMS Publishing Points ACL Authorization");
my $User_Custom = $User_Control->CustomInterface();
my $User_List = $User_Custom->AccessControlList();
foreach my $user ( keys %{$limit_parameters} )
	{
	my $user_mask = ${$limit_parameters}{$user};
	my $user_value;
	foreach my $mask_name ( split(/,/,$user_mask) )
		{ foreach my $limit_names ( keys %{$limit_variables} )
			{ if ( $mask_name=~/${$limit_variables}{$limit_names}/i )
				{ if ( $mask_name=~/^AllowAll$/i || $mask_name=~/^DenyAll$/i )
					{ $user_value=$limit_names; }
					else
					{ $user_value+=$limit_names; }
				} } }
	my $add_user=$User_List->Add( $user, $user_value );
	}
return 1;
}

sub Publishing_Point_Authorization_ACL_Remove
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $limit_parameters = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $User_Control = $publishing_point ->EventHandlers("WMS Publishing Points ACL Authorization");
my $User_Custom = $User_Control->CustomInterface();
my $User_List = $User_Custom->AccessControlList();
foreach my $user ( @{$limit_parameters} )
        {
        my $add_user=$User_List->Remove( $user );
        }
return 1;
}

sub Publishing_Point_Authorization_IPAddress_Add
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $ip_list_type = shift;
my $limit_parameters = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
if ( $ip_list_type!~/^AllowIP$/ && $ip_list_type!~/^DisallowIP$/ )
	{ $self->set_error("AllowIP or DisallowIP are the only valid types requested '$ip_list_type'"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $IP_Control = $publishing_point ->EventHandlers("WMS IP Address Authorization");
my $IP_Custom = $IP_Control->CustomInterface();
my $IPList = ${$IP_Custom}{$ip_list_type};
foreach my $entry (@{$limit_parameters})
	{
	# Probably need to put some IP address and mask checking
	# in here so not to pass crap to the WindowsMediaService as it appears
	# to go a little screwy if you do.
	my ( $address, $netmask ) = (split(/,/,$entry))[0,1];
	$IPList->Add( $address, $netmask );
	}
return 1;
}

sub Publishing_Point_Authorization_IPAddress_Remove
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $ip_list_type = shift;
my $limit_parameters = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
if ( $ip_list_type!~/^AllowIP/ && $ip_list_type!~/^DisallowIP/ )
        { $self->set_error("AllowIP or DisallowIP are the only valid types requested '$ip_list_type'"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $IP_Control = $publishing_point ->EventHandlers("WMS IP Address Authorization");
my $IP_Custom = $IP_Control->CustomInterface();
my $IPList = ${$IP_Custom}{$ip_list_type};
if ( ${$IPList}{'Count'}>0 )
	{
	foreach my $address (@{$limit_parameters})
        	{
		for ( $a=0; $a<${$IPList}{'Count'}; $a++ )
			{
			my $ip_entry = ${$IPList}{$a};
			if ( ${$ip_entry}{'Address'}=~/$address/ )
				{
				$IPList->Remove ($a);
				}
			}
		}
	}
return 1;
}

sub Publishing_Point_General_Set
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my %limit_parameters = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $limit_variables = Win32::WindowsMedia::BaseVariables->PublishingPointGeneral();
foreach my $limit_name ( keys %limit_parameters )
	{
	if ( ${$limit_variables}{$limit_name} )
		{ $publishing_point->{ ${$limit_variables}{$limit_name} }=$limit_parameters{$limit_name}; }
	}
return 1;
}

sub Publishing_Point_General_Get
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $limit_values = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $limit_variables = Win32::WindowsMedia::BaseVariables->PublishingPointGeneral();
foreach my $limit_name ( keys %{$limit_variables} )
	{ ${$limit_values}{$limit_name}=${$publishing_point}{$limit_name}; }
return 1;
}

sub Publishing_Point_Limits_Set
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my %limit_parameters = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $Limits = $publishing_point->{Limits};
my $limit_variables = Win32::WindowsMedia::BaseVariables->PublishingPointLimits();
foreach my $limit_name ( keys %limit_parameters )
	{
	if ( ${$limit_variables}{$limit_name} )
		{ $Limits->{ ${$limit_variables}{$limit_name} }=$limit_parameters{$limit_name}; }
	}
return 1;
}

sub Publishing_Point_Limits_Get
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $limit_values = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $Limits = $publishing_point->{Limits};
my $limit_variables = Win32::WindowsMedia::BaseVariables->PublishingPointLimits();
foreach my $limit_name ( keys %{$limit_variables} )
	{ ${$limit_values}{$limit_name}=${$Limits}{$limit_name}; }
return 1;
}

sub Publishing_Point_Start
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
if ( ${$publishing_point}{'Path'}=~/^push:\*/i )
        { $self->set_error("Push Publishing Points Can Not Be Started"); return 0; }
$publishing_point->Start();
return 1;
}

sub Publishing_Point_Stop
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
if ( ${$publishing_point}{'Path'}=~/^push:\*/i )
	{ $self->set_error("Push Publishing Points Can Not Be Stopped"); return 0; }
$publishing_point->Stop();
return 1;
}

sub Publishing_Point_Remove
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;

if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
my $publishing_points = $server_object->PublishingPoints;
my $publishing_point_del = $publishing_points->Remove(
                                $publishing_point_name
				);
undef $publishing_points;
if ( !$publishing_point_del )
	{ $self->set_error("Publishing Point Remove Error"); return 0; }
return $publishing_point_del;
}

sub Publishing_Point_Create
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $publishing_point_url = shift;
my $publishing_point_type = shift;

# type can be a name or number,
# 'OnDemand', 'Broadcast', 'CacheProxyOnDemand', 'CacheProxyBroadcast'
my $real_pub_point_type=0;

my $limit_variables = Win32::WindowsMedia::BaseVariables->PublishingPointType();
foreach my $pub_type ( keys %{$limit_variables} )
	{
	if ( ${$limit_variables}{$pub_type}=~/$publishing_point_type/i )
		{
		$real_pub_point_type=$pub_type;
		}
	}

if ( !$real_pub_point_type )
	{
	my $publishing_point_types;
	foreach my $pub_type ( keys %{$limit_variables} )
		{ $publishing_point_types.="${$limit_variables}{$pub_type},"; }
	chop($publishing_point_types);
	$self->set_error("Invalid Publishing Point Type Specified must be one of $publishing_point_types");
	undef $publishing_point_types;
	return 0;
	}

$publishing_point_url="push:*" if !$publishing_point_url;

if ( $publishing_point_name!~/^[0-9a-zA-Z]+$/ )
	{
	$self->set_error("Publishing Point Name Invalid");
	return 0;
	}

if ( length($publishing_point_name)<3 )
	{
	$self->set_error("Publishing Point Name Too Short");
	return 0;
	}

if ( !$server_object )
	{
	$self->set_error("Server Object Not Set");
	return 0;
	}

if ( $server_object->PublishingPoints($publishing_point_name) )
	{
	$self->set_error("Publishing Point Already Defined");
	return 0;
	}

my $publishing_points = $server_object->PublishingPoints;

my $publishing_point_new = $publishing_points->Add( 
				$publishing_point_name,
				$real_pub_point_type,
				$publishing_point_url );

if ( !$publishing_point_new )
	{
	$self->set_error("Publishing Point Creation Failed");
	return 0;
	}

undef $publishing_points;

return $publishing_point_new;
}

sub set_error
{
my $self = shift;
my $error = shift;
$self->{_GLOBAL}{'STATUS'} = $error;
return 1;
}

sub get_error
{
my $self = shift;
return $self->{_GLOBAL}{'STATUS'};
}

=head1 AUTHOR

Andrew S. Kennedy, C<< <shamrock at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-win32-windowsmedia-provision at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Win32-WindowsMedia-Provision>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

L<http://search.cpan.org/dist/Win32-WindowsMedia-Provision>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Andrew S. Kennedy, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Win32::WindowsMedia::Provision
