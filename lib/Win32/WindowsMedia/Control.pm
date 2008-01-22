package Win32::WindowsMedia::Control;

use warnings;
use strict;

=head1 NAME

Win32::WindowsMedia::Control - The control module for Windows Media

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use Win32::WindowsMedia::Control;

=head1 FUNCTIONS

=head2 Playlist_Jump_To_Event

    This function should only be used WHEN YOU KNOW WHAT YOU ARE DOING!

    It will not break anything, however requires much more than just a
publishing point name and event name to work.

    Playlist_Jump_To_Event(
		$Server_Object,
		"<Publishing Point Name>",
		"<Event Name>"
			);

Example of Use

    my $result = $Control->Playlist_Jump_To_Event(
		$Server_Object,
		"andrew",
		"event1");

=head2 Playlist_Build

    This function builds a server side playlist. An array of filenames 
are required and a single string is required. This function does not use
internal playlist functions.

    Playlist_Build( <pointer to filename array> );

    ( not yet available )

Example of Use

    my $playlist = $Control->Playlist_Build(\@filename_array);

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

sub Playlist_Jump_To_Event
{
my $self = shift;
my $server_object = shift;
my $publishing_point_name = shift;
my $event_name = shift;
if ( !$server_object )
        { 
	$self->set_error("Server Object Not Set"); 
	return 0; 
	}

if ( !$server_object->PublishingPoints($publishing_point_name) )
        { 
	$self->set_error("Publishing Point Not Defined"); 
	return 0; 
	}

my $publishing_point = $server_object->PublishingPoints( $publishing_point_name );
if ( $publishing_point->{BroadCastStatus}!=2 )
	{ 
	$self->set_error("Publishing Point Not Active"); 
	return 0; 
	}

my $publishing_point_playlist = $publishing_point->{SharedPlaylist};
if ( !$publishing_point_playlist ) 
	{ 
	$self->set_error("Playlist not defined"); 
	return 0; 
	}

my $error = $publishing_point_playlist->FireEvent( $event_name );
return 1;
}

=cut

=head1 AUTHOR

Andrew S. Kennedy, C<< <shamrock at cpan.org> >>

=head1 BUGS

=head1 SUPPORT

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Win32-WindowsMedia-Provision>

=item * Search CPAN

L<http://search.cpan.org/dist/Win32-WindowsMedia-Provision>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 Andrew S. Kennedy, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Win32::WindowsMedia::Control
