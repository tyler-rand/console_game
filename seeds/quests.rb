QUESTS = [
  {
    name: 'Welcome to ConsoleRPG',
    level: 1,
    start_location: [13, 13],
    map_name: 'Trainers Court',
    requirements: { kills: 5 },
    start_text: '> Welcome to ConesoleRPG! Complete the first quest by getting 5 kills in Trainer\'s Court.',
    end_text: '> Good job completing your first quest!',
    xp_reward: 10,
    cash_reward: 100,
    item_reward: nil,
    triggers: [
      { killed_mob: { map: 'Trainers Court' } }
    ],
    progress: { kills: 0 }
  },
  {
    name: 'Kill Professor Gulbrand',
    level: '2',
    start_location: [14, 10],
    map_name: 'Trainers Court',
    requirements: { mob_killed: 1 },
    start_text: '> Kill the evil Professor that lives in the court.',
    end_text: '> Professor Gulbrand slain!',
    xp_reward: 15,
    cash_reward: 100,
    item_reward: nil,
    triggers: [
      { killed_mob: { mob: 'Professor Gulbrand' } }
    ],
    progress: { mob_killed: 0 }
  },
  {
    name: 'Clear Trainers Mansion',
    level: 2,
    start_location: [22, 5],
    map_name: 'Trainers Mansion',
    requirements: { kills: 5 },
    start_text: '> Do your part in clearing the mansion by getting 5 kills.',
    end_text: '> Great job!',
    xp_reward: 15,
    cash_reward: 100,
    item_reward: nil,
    triggers: [
      { killed_mob: { map: 'Trainers Mansion' } }
    ],
    progress: { kills: 0 }
  }
].freeze
