class CreateCoursework < ActiveRecord::Migration
  def self.up
    # the coursework consists of exercises, questionnaires, etc
    create_table :courseworks, :force => true do |t|
      t.string    :title,                  :limit => 64, :null => false
      t.integer   :project_id,             :null => false
      t.integer   :max_group_size,         :default => 1
      t.text      :description
      t.timestamp :starts_at,              :null => false
      t.timestamp :due_before,             :null => false
      
      t.timestamps
    end

    # each coursework has a number of tasks (questions, ...)
    create_table :coursework_tasks do |t|
      t.integer   :coursework_id,          :null => false
      t.string    :title,                  :limit => 32, :null => false
      t.integer   :max_points,             :default => 0
      t.integer   :extra_points,           :default => 0
    end

    # each coursework also has answers from the student (consisting of one or
    # more files that solve the task for this coursework - there is no
    # specific mapping of an answer to a task)
    create_table :coursework_answers do |t|
      t.integer   :coursework_id
      t.integer   :teacher_id
      t.boolean   :is_graded,              :default => false

      t.timestamps
    end

    # join table to assign multiple users to an answer
    create_table :coursework_answers_users, :id => false do |t|
      t.integer   :coursework_answer_id,   :null => false
      t.integer   :user_id,                :null => false
    end

    # grading is done per task so there can be individual remarks / points
    create_table :coursework_gradings do |t|
      t.integer  :coursework_answer_id,    :null => false
      t.integer  :coursework_task_id,      :null => false
      t.text     :remarks
      t.integer  :points

      t.timestamps
    end
  end

  def self.down
    drop_table :courseworks
    drop_table :coursework_tasks
    drop_table :coursework_answers
    drop_table :coursework_answers_users
    drop_table :coursework_grading
  end
end
