task :balance => :environment do
  BalanceUpdater.update_balances_from_ps
end