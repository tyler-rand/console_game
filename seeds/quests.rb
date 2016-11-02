QUESTS = [
  {
    name: 'Welcome to ConsoleRPG',
    level: 1,
    location: [13, 13],
    map_name: 'Trainers Court',
    requirements: { 'kills': 5 },
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
    name: 'Clear Trainers Mansion',
    level: 2,
    location: [22, 5],
    map_name: 'Trainers Mansion',
    requirements: { 'kills': 5 },
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
]
