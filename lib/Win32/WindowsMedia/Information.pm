package Win32::WindowsMedia::Information;

use warnings;
use strict;

=head1 NAME

Win32::WindowsMedia::Information - The information module for WindowsMedia

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Win32::WindowsMedia::Information;

=head1 FUNCTIONS

=head2 Publishing_Point_Players_Get

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

sub Publishing_Point_Authorization_IPAddress_Get
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $ip_list_type = shift;
my $limit_values = shift;
if ( !$server_object )
        { $self->set_error("Server Object Not Set"); return 0; }
if ( !$server_object->PublishingPoints($publishing_point_name) )
        { $self->set_error("Publishing Point Not Defined"); return 0; }
if ( $ip_list_type!~/^AllowIP/ || $ip_list_type!~/^DisallowIP/ )
        { $self->set_error("AllowIP or DisallowIP are the only valid types"); return 0; }
my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
my $IP_Control = $publishing_point ->EventHandlers("WMS IP Address Authorization");
my $IP_Custom = $IP_Control->CustomInterface();
my $IPList = ${$IP_Custom}{$ip_list_type};
# variables should be 'Address' and 'Mask'
if ( ${$IPList}{'Count'} > 0 )
	{
	for ($a=0; $a<${$IPList}{'Count'}; $a++ )
		{
		my $ip_entry = ${$IPList}{$a};
		foreach my $variable ( keys %{$ip_entry} )
			{
			${$limit_values}{$a}{$variable}=${$ip_entry}{$variable};
			}
		}
	}
return 1;
}

sub Publishing_Point_Players_Get
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
my $players = $publishing_point ->{Players};
my $player_status = Win32::WindowsMedia::BaseVariables->PlayerStatus();
if ( ${$players}{'Count'}>0 )
	{
	for ( $a=0; $a<${$players}{'Count'}; $a++ )
		{
		my $ip_client = ${$players}{$a};
		foreach my $variable ( keys %{$ip_client} )
			{
			${$limit_values}{$a}{$variable}= ${$ip_client}{$variable};
			}
		${$limit_values}{$a}{'Status'}=${$player_status}{ ${$limit_values}{$a}{'Status'} };
		}
	}
return 1;
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

=cut

sub function2 {
}

=head1 AUTHOR

Andrew S. Kennedy, C<< <shamrock at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-win32-windowsmedia-information at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Win32-WindowsMedia-Provision>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

=item * Search CPAN

L<http://search.cpan.org/dist/Win32-WindowsMedia-Provision>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Andrew S. Kennedy, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Win32::WindowsMedia::Information
