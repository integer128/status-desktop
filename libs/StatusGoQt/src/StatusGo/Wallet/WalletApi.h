#pragma once

#include "Accounts/ChatOrWalletAccount.h"
#include "Accounts/accounts_types.h"
#include "BigInt.h"

#include "DerivedAddress.h"
#include "NetworkConfiguration.h"
#include "Token.h"

#include "Types.h"

#include <vector>

namespace Accounts = Status::StatusGo::Accounts;

namespace Status::StatusGo::Wallet
{
/// \brief Retrieve a list of derived account addresses
/// \see \c generateAccountWithDerivedPath
/// \throws \c CallPrivateRpcError
DerivedAddresses getDerivedAddressesForPath(const HashedPassword &password, const Accounts::EOAddress &derivedFrom, const Accounts::DerivationPath &path, int pageSize, int pageNumber);

/// \note status-go's GetEthereumChains@api.go which calls
///       NetworkManager@client.go -> network.Manager.get()
/// \throws \c CallPrivateRpcError
NetworkConfigurations getEthereumChains(bool onlyEnabled);

/// \note status-go's GetEthereumChains@api.go which calls
///       NetworkManager@client.go -> network.Manager.get()
/// \throws \c CallPrivateRpcError
NetworkConfigurations getEthereumChains(bool onlyEnabled);


/// \note status-go's GetTokens@api.go -> TokenManager.getTokens@token.go
/// \throws \c CallPrivateRpcError
Tokens getTokens(const ChainID &chainId);

using TokenBalances = std::map<Accounts::EOAddress, std::map<Accounts::EOAddress, BigInt>>;
/// \note status-go's @api.go -> <xx>@<xx>.go
/// \throws \c CallPrivateRpcError
TokenBalances getTokensBalancesForChainIDs(const std::vector<ChainID> &chainIds,
                                           const std::vector<Accounts::EOAddress> accounts,
                                           const std::vector<Accounts::EOAddress> tokens);
} // namespaces
