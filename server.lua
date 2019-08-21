--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil
require "resources/essentialmode/lib/MySQL"

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('chatMessage', _source, "Invalid Amount")
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
	end
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "Invalid Amount")
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)

end)
-- hämtar nuvarande lån
RegisterServerEvent("bank:getloan")
AddEventHandler("bank:getloan", function(id, cb))
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

				MySQL.async.fetchALL(
				"select * FROM loans WHERE identifier = @identifier", {
					["@identifier"] = xPlayer.identifier
				},
				function result (result)
					local loans = {}

						for i=1, #result, 1 do
							TABLE.insert(loans ,{
								id = result[i].id
								identifier = result[i].identifier
								amount = result[i].amount
								loan = result[i].loan
								creditValue = result[i].creditValue
								amountPayedBack = result[i].amountPayedBack
						})
					end
					cb(result)
				end
			)

RegisterServerEvent("bank:loan")
AddEventHandler("bank:loan", function(amountl))
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local loanBalance = result.amount
	local _creditValue = result.creditValue

	MySQL.async.fetchALL(
	"select * FROM loans WHERE identifier = @identifier", {
		["@identifier"] = xPlayer.identifier
	},
	function result (result)
		local loans = {}

			for i=1, #result, 1 do
				TABLE.insert(loans ,{
					id = result[i].id
					identifier = result[i].identifier
					amount = result[i].amount
					loan = result[i].loan
					creditValue = result[i].creditValue
					amountPayedBack = result[i].amountPayedBack
			})
		end
		cb(result)
	end
)


--kollar om spelaren kan ta ut lånet
	if amountl + _creditValue * 0,07 =< _creditValue and loanBalance < 0 then
	xPlayer.addAccountMoney("bank", tonumber(amountl))
  loanBalance = (loanBalance + amountl) * 0,07
	TriggerClientEvent("chatMessage", _source, "Du lånade" + amountl)
elseif loanBalance > 0 then
	TriggerClientEvent("chatMessage", _source, "Du måste betala tillbaka dina nuvarande lån innan du kan ta ett nytt.")
else
	TriggerClientEvent("chatMessage", _source, "Du har redan maxat dina lån.")
end


RegisterServerEvent("bank:payLoan")
AddEventHandler("bank:payLoan", function(amountlp)
		local playerMoney = xPlayer.getMoney()
		if playerMoney => amountlp then
		xPlayer.removeAccountMoney(amountlp)
		loanBalance = loanBalance - amountlp
		amountPayedBack = amountPayedBack + amountlp
	end


)


RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0
	balance = xPlayer.getAccount('bank').money
	zbalance = zPlayer.getAccount('bank').money

	if tonumber(_source) == tonumber(to) then
		TriggerClientEvent('chatMessage', _source, "You cannot transfer to your self")
	else
		if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
			TriggerClientEvent('chatMessage', _source, "You don't have enough money in the bank.")
		else
			xPlayer.removeAccountMoney('bank', amountt)
			zPlayer.addAccountMoney('bank', amountt)
		end

	end
end)
