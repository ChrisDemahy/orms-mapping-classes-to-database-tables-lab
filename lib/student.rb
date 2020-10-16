

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
# Describes an Student
class Student
  ### CLASS DEFINITIONS ###

  # Create a database table for this class
  def self.create_table
    table_sql = <<-SQL

    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      grade INTEGER
      )

    SQL


    DB[:conn].execute(table_sql)
    
  end

  # Removes the entire students table from the database
  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def self.create(name: nil, grade: nil)
    student = Student.new(name, grade)
    student.save()
    student
  end

  ### INSTANCE DEFINITIONS ###

  # instance readers and writers
  attr_accessor :name, :grade
  attr_reader :id

  # default constructor
  def initialize(name=nil, grade=nil, id=nil)
    self.name = name
    self.grade = grade
    @id = id
  end

  def save
    save_sql = <<-SQL

      INSERT INTO
        students (name, grade)
      VALUES
        (?, ?)

    SQL

    id_sql = <<-SQL

    SELECT 
      last_insert_rowid() 
    FROM 
      students

    SQL

    DB[:conn].execute(save_sql, self.name, self.grade)
    @id = DB[:conn].execute(id_sql)[0][0]
  end

end
