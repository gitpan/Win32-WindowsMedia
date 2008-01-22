package Win32::WindowsMedia;

use warnings;
use strict;
use Win32::OLE qw( in with HRESULT );
use Win32::OLE::Const "Windows Media Services Server Object Model and Plugin 9.0 Type Library";
use Win32::WindowsMedia::Provision;
use Win32::WindowsMedia::Control;
use Win32::WindowsMedia::Information;
use Win32::WindowsMedia::BaseVariables;

=head1 NAME

Win32::WindowsMedia - Base Module for Provisiong and control for Windows Media Services

=head1 VERSION

Version 0.16

=cut

our $VERSION = '0.16';

=head1 SYNOPSIS

This is a module to control Windows Media services for a Windows 2003/2008 server. This 
is the second pre-alpha release and primarily contains more documentation. At present
this is 4 modules that contain seperation of functions.

    use Win32::WindowsMedia;
    use strict;

    my $main =new Win32::WindowsMedia;
    my $provisioner =new Win32::WindowsMedia::Provision;
    my $information =new Win32::WindowsMedia::Information; 
    my $controller =new Win32::WindowsMedia::Control;

    my $server_object = $main->Server_Create("127.0.0.1");

    my $publishing_point = $provisioner->
		Publishing_Point_Create( $server_object, "andrew", "push:*", "broadcast" );

=head1 FUNCTIONS

=item C<< Server_Create >>

This function create an instance to communicate with the Windows Media Server running. You
can specify an IP address, however 99% of the time it should be one of the local interface
IPs or localhost(127.0.0.1). It does not matter which IP is used as Windows Media services
is not bound to a specific IP.

    Server_Create( "<IP>" );

Example of Use

    my $server_object = $main->Server_Create("127.0.0.1");

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

sub Server_Create
{
my $self = shift;
my $server_ip = shift;

if ( !$server_ip )
	{
	$self->set_error("IP Address of Windows Media Server required");
	return 0;
	}

my $server_object = new Win32::OLE( [ $server_ip , "WMSServer.Server" ] );

if ( !$server_object )
        {
        $self->set_error("OLE Object Failed To Initialise");
        # need to add error capture here
        return 0;
        }

return $server_object;
}

sub _set_error
{
my $self = shift;
my $error = shift;
$self->{_GLOBAL}{'STATUS'} = $error;
return 1;
}

sub _get_error
{
my $self = shift;
return $self->{_GLOBAL}{'STATUS'};
}


=head1 AUTHOR

Andrew S. Kennedy, C<< <shamrock at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-win32-windowsmedia at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Win32-WindowsMedia>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Win32-WindowsMedia>

=item * Search CPAN

L<http://search.cpan.org/dist/Win32-WindowsMedia>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 Andrew S. Kennedy, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Win32::WindowsMedia
