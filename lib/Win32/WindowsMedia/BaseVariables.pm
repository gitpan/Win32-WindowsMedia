package Win32::WindowsMedia::BaseVariables;

use warnings;
use strict;

=head1 NAME

Win32::WindowsMedia::BaseVariables - The control module for Windows Media

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use Win32::WindowsMedia::BaseVariables;

=head1 FUNCTIONS

=head2 ServerType

    This function returns types and values for possible Windows Media Servers

    The possible values are

    Standard/Server
    Advanced/Enterprise

=head2 PublishingPointLimits

    This returns the Publishing Point limit variable names that can be used to set
the limits on the publishing point. Provided are the names of the internal references
used by Windows Media Services, and those displayed on the Windows Media Services management
console.

    Windows Media Services Management variables names

    LimitPlayerConnections
    LimitOutgoingDistributionBandwidth(kbps)
    LimitOutgoingDistributionConnections
    LimitBandwidthPerOutgoingDistributionStream(kbps)
    LimitAggregatePlayerBandwidth(kbps)
    LimitBandwidthPerStreamPerPlayer(kbps)
    LimitFastStartBandwidthPerPlayer(kbps)

    Windows Media Services internal variables names

    ConnectedPlayers
    OutgoingDistributionBandwidth
    OutgoingDistributionConnections
    PerOutgoingDistributionConnectionBandwidth
    PlayerBandwidth
    PerPlayerConnectionBandwidth
    PlayerCacheDeliveryRate*
    FECPacketSpan*
    PerPlayerRapidStartBandwidth

    *These variables are not show on the management console and should
    be changed/set with care.

    The returned hash contains a mapping of external/internal name to internal name.

=head2 PublishingPointGeneral

    This returns the Publihsing Point general variable names that can be used to set
certain properties of the stream.

    Windows Media Services Management variables names

    EnableFastCached
    EnableStreamSplitting
    StartPublishingPointWhenFirstClientConnects
    EnableBroadcastAutoStart
    EnableAdvancedFastStart

    Windows Media Services internal variables names

    AllowPlayerSideDiskCaching
    AllowStreamSplitting
    AllowClientToStartAndStop
    EnableStartVRootOnServiceStart
    AllowStartupProfile
    AllowClientsToConnect
    MonikerName
    Name
    Path
    Type
    Status
    EnableWrapperPath
    DistributionUserName
    CacheProxyExpiration
    IsDistributionPasswordSet
    AllowStreamSplitting
    AllowClientToStartAndStop
    BroadcastStatus
    UpTime
    BufferSetting

    The returned hash contains a mapping of external/internal name to internal name.

=head2 PlayerStatus

    This function returns the possible player conditions

    Disconnected
    Idle
    Open
    Streaming

=head2 UserAccessSettings

    This function returns the values and states available for users that are configured
for access control to the publishing point. 
 
    The possible states are

    ACCESSINIT
    ReadDeny
    WriteDeny
    CreateDeny
    AllDeny
    UNKNOWN
    ReadAllow
    WriteAllow
    CreateAllow
    AllAllow

=head2 ServerLogCycle

    This function returns the values and states for the automatic log file cycler. 

    The possible states are

    None
    Size
    Month
    Week
    Day
    Hour

=head2 PublishingPointType

    This function returns the values and types for a publishing point

    The possible states are

    OnDemand
    Broadcast
    CacheProxyOnDemand
    CacheProxyBroadcast

=head2 PublishingPointBroadCastStatus

    This function returns the values and states available for a publishing point

    The possible states are

    Stopped
    Started No Data
    Started
    Archiving
    Change In Progress

=head2 ActiveStreamType

    This function returns the values and types for a stream

    The possible states are

    Video
    Audio
    Other

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

sub ServerType
{
my %ServerType =
	(
	1	=>	'Standard/Server',
	2	=>	'Advanced/Enterprise'
	);
return \%ServerType;
}


sub PublishingPointGeneral
{

my %publishing_point_general =
	(
	'AllowClientsToConnect'		=>	'AllowClientsToConnect',
	'MonikerName'			=>	'MonikerName',
	'Name'				=>	'Name',
	'Path'				=>	'Path',
	'Type'				=>	'WrapperPath',
	'Status'			=>	'Status',
	'EnableWrapperPath'		=>	'EnableWrapperPath',
	'DistributionUserName'		=>	'DistributionUserName',
	'CacheProxyExpiration'		=>	'CacheProxyExpiration',
	'IsDistributionPasswordSet'	=>	'IsDistributionPasswordSet',
	'AllowPlayerSideDiskCaching'	=>	'AllowPlayerSideDiskCaching',
	'EnableFEC'			=>	'EnableFEC',
	'AllowStreamSplitting'		=>	'AllowStreamSplitting',
	'AllowClientToStartAndStop'	=>	'AllowClientToStartAndStop',
	'BroadcastStatus'		=>	'BroadcastStatus',
	'UpTime'			=>	'UpTime',
	'BufferSetting'			=>	'BufferSetting',
	'AllowStartupProfile'		=>	'AllowStartupProfile',
	'EnableStartVRootOnServiceStart'=>	'EnableStartVRootOnServiceStart',
# mappings from console start here
	'EnableFastCache'		=>	'AllowPlayerSideDiskCaching',
	'EnableStreamSplitting'		=>	'AllowStreamSplitting',
	'StartPublishingPointWhenFirstClientConnects'	=>	'AllowClientToStartAndStop',
	'EnableBroadcastAutoStart'	=>	'EnableStartVRootOnServiceStart',
	'EnableAdvancedFastStart'	=>	'AllowStartupProfile'
	);

return \%publishing_point_general;
}

sub PublishingPointLimits
{
my %publishing_point_limits =
                (
                'LimitPlayerConnections'                      =>      'ConnectedPlayers',
                'LimitOutgoingDistributionBandwidth(kbps)'      =>      'OutgoingDistributionBandwidth',
                'LimitOutgoingDistributionConnections'          =>      'OutgoingDistributionConnections',
                'LimitBandwidthPerOutgoingDistributionStream(kbps)'     =>      'PerOutgoingDistributionConnectionBandwidth',
                'LimitAggregatePlayerBandwidth(kbps)'           =>      'PlayerBandwidth',
                'LimitBandwidthPerStreamPerPlayer(kbps)'        =>      'PerPlayerConnectionBandwidth',
                'PlayerCacheDeliveryRate'                       =>      'PlayerCacheDeliveryRate',
                'FECPacketSpan'                                 =>      'FECPacketSpan',
                'LimitFastStartBandwidthPerPlayer(kbps)'        =>      'PerPlayerRapidStartBandwidth',
                'ConnectedPlayers'                              =>      'ConnectedPlayers',
                'OutgoingDistributionBandwidth'                 =>      'OutgoingDistributionBandwidth',
                'OutgoingDistributionConnections'               =>      'OutgoingDistributionConnections',
                'PerOutgoingDistributionConnectionBandwidth'    =>      'PerOutgoingDistributionConnectionBandwidth',
                'PlayerBandwidth'                               =>      'PlayerBandwidth',
                'PerPlayerConnectionBandwidth'                  =>      'PerPlayerConnectionBandwidth',
                'PlayerCacheDeliveryRate'                        =>      'PlayerCacheDeliveryRate',
                'FECPacketSpan'                       =>      'FECPacketSpan',
                'PerPlayerRapidStartBandwidth'                  =>      'PerPlayerRapidStartBandwidth'
                );

return \%publishing_point_limits;
}

sub PlayerStatus
{
my %PlayerStatus =
		(
		0		=> 'Disconnected',
		1		=> 'Idle',
		2		=> 'Open',
		3		=> 'Streaming'
		);
return \%PlayerStatus;
}

sub UserAccessSettings
{
my %UserAccessSettings =
		(
		0		=>	'ACCESSINIT',
		1		=>	'ReadDeny',
		2		=>	'WriteDeny',
		4		=>	'CreateDeny',
		7		=>	'AllDeny',
		8		=>	'UNKNOWN',
		16		=>	'ReadAllow',
		32		=>	'WriteAllow',
		64		=>	'CreateAllow',
		112		=>	'AllAllow'
		);
return \%UserAccessSettings;
}

sub ServerLogCycle
{
my %ServerLogCycle =
		(
		0 	=>	'None',	
		1	=>	'Size',
		2	=>	'Month',
		3	=>	'Week',
		4	=>	'Day',
		5	=>	'Hour'
		);

return \%ServerLogCycle;
}

sub PublishingPointType
{
my %PublishingPointType =
		(
		1	=>	'OnDemand',
		2	=>	'Broadcast',
		3	=>	'CacheProxyOnDemand',
		4	=>	'CacheProxyBroadcast'
		);
return \%PublishingPointType;
}

sub PublishingPointBroadCastStatus
{
my %PublishingPointBroadCastStatus =
		(
		0	=>	'Stopped',
		1	=>	'Started No Data',
		2	=>	'Started',
		3	=>	'Archiving',
		4	=>	'Change In Progress'
		);
return \%PublishingPointBroadCastStatus;
}

sub ActiveStreamType
{
my %StreamType =
		(
		0	=>	'Video',
		1	=>	'Audio',
		2	=>	'Other'
		);

return \%StreamType;
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

Copyright 2006 Andrew S. Kennedy, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Win32::WindowsMedia::Control
