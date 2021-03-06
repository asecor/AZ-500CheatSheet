# This code is an interpretation of the Azure Forced Tunneling docs site found here: 
# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-forced-tunneling-rm

# Create a route table name MyRouteTable
New-AzRouteTable -name "MyRouteTable" -ResourceGroupName 'demo-rg' -Location 'centralus'
$rt = get-azroutetable -name 'MyRouteTable' -ResourceGroupName 'demo-rg'
$vnet = Get-AzVirtualNetwork -ResourceGroupName 'demo-rg'

# Add a route config to have the next hop be the Virtual Network Gateway and assigning the new route table
add-azrouteconfig -name "DefaultRoute" -AddressPrefix '0.0.0.0/0' -NextHopType VirtualNetworkGateway -RouteTable $rt
Set-AzRouteTable -RouteTable $rt

# Configuring the subnet with new route table
Set-AzVirtualNetworkSubnetConfig -name 'demo-sn' -VirtualNetwork $vnet -AddressPrefix '192.168.1.0/24' -RouteTable $rt
Set-AzVirtualNetwork -VirtualNetwork $vnet

# Final piece to get the forced tunneling to work by setting the default site to be local gw
$localgw = get-azlocalnetworkgateway -ResourceGroupName 'demo-rg'
$azvirtualgw = get-azvirtualnetworkgateway -ResourceGroupName 'demo-rg'
Set-AzVirtualNetworkGatewayDefaultSite -GatewayDefaultSite $localgw -VirtualNetworkGateway $azvirtualgw
