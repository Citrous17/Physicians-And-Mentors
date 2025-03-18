# Creating Specialties
specialties = ["Cardiology", "Neurology", "Orthopedics", "Pediatrics", "Dermatology"].map do |name|
    Specialty.create!(name: name)
  end
  
  # Creating Users
  users = 10.times.map do |i|
    User.create!(
        last_name: "Last#{i}",
        first_name: "First#{i}",
        email: "user#{i}@example.com",
        password: "password#{i}",
        location: "City#{i}",
        DOB: Date.parse("199#{i}-01-01"),
        phone_number: i.even? ? "123-456-789#{i}" : '123-456-7890',
        profile_image_url: "https://example.com/profile#{i}.jpg",
        isProfessional: [true, false].sample,
        user_id: i,
        isAdmin: false
      )
  end

  # Create my user
  User.create!(
    last_name: "Last",
    first_name: "First",
    email: "citrous@tamu.edu",
    password: "password",
    location: "College Station",
    DOB: Date.parse("1999-01-01"),
    phone_number: "123-456-7890",
    profile_image_url: "https://example.com/profile.jpg",
    isProfessional: true,
    user_id: 12,
    isAdmin: true
  )
  
  # Assigning Physician Specialties
  users.each do |user|
    if user.isProfessional
      PhysicianSpecialty.create!(
        user_id: user.id,
        specialty_id: specialties.sample.id
      )
    end
  end
  
  # Creating Posts
  posts = []
    10.times do |i|
    post = Post.create!(
        content: "This is post content #{i}",
        title: "Post Title #{i}",
        sending_user: User.all.sample, # Ensure users exist
        specialties: [Specialty.all.sample]
    )
    posts << post
  end
  
  # Creating Admins
  Admin.create!(
    user_id: users.sample.id,
    canEditDatabase: true
  )
  
  puts "Seed data successfully created!"
  
