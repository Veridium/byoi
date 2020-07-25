product1 = Product.create(
	 name: "Sovrin",
	 logo: "https://www.dropbox.com/s/0msvadhter987l0/sovrin-logo-large.png?raw=1",
	 icon: "https://www.dropbox.com/s/einr6jm13tgm7n3/sovrin-ico.png?raw=1")
product2 = Product.create(
	 name: "Veres One",
	 logo: "https://www.dropbox.com/s/rzkejkt89pusiy7/veres_one_logo.png?raw=1",
	 icon: "https://www.dropbox.com/s/nnkzhamf8e8ddc1/veres_one_ico.png?raw=1")
plan1 = Plan.create(
      name: "Sovrin Credentials",
      product_id: product1.id,
      description: "Verifiable credentials registered on the Sovrin network",
      price: 50,
      duration: 31557600)
plan1 = Plan.create(
      name: "Veres One Credentials",
      product_id: product2.id,
      description: "Verifiable credentials registered on the Veres One network",
      price: 10,
      duration: 31557600)
User.create(
	email: "admin@example.com",
	password: "pAssw0rd",
	admin: true,
	confirmed_at: 2.days.ago)
