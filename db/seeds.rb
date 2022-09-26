# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

priority = Priority.create!(name: '高')
Priority.create!(
  [
    {
      name: '中'
    },
    {
      name: '低'
    }
  ]
)

task_status = TaskStatus.create!(name: '未着手')
TaskStatus.create!(
  [
    {
      name: '着手中'
    },
    {
      name: '完了'
    }
  ]
)

User.create!(
  [
    {
      email: 'test1@test.com',
      name: 'test admin',
      password: 'password111111',
      is_admin: true
    },
    {
      email: 'test2@test.com',
      name: 'test general',
      password: 'password222222',
      is_admin: false
    }
  ]
)

User.all.each do |user|
  20.times do |n|
    user.tasks.create!(
      name: "test task#{n + 1}",
      detail: "test detail#{n + 1}",
      deadline: Time.zone.tomorrow,
      task_status_id: task_status.id,
      priority_id: priority.id
    )
  end
end

30.times do |n|
  Tag.create!(
    name: "tag#{n + 1}"
  )
end

Task.all.each do |task|
  TaskTagRelationship.create!(
    task_id: task.id,
    tag_id: rand(1..30)
  )
end

# now = Time.zone.now
# 100.times do |n|
#   Task.create!(
#     name: "test task#{n + 1}",
#     detail: "test detail#{n + 1} created by seed",
#     deadline: now.since(rand(1..50).days),
#     task_status_id: rand(1..3),
#     priority_id: rand(1..3),
#     user_id: 8
#   )
# end
