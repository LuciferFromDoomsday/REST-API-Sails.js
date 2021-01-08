
///Users/admin/.npm-global/lib/node_modules/sails/bin/sails.js lift
// to use sails in terminal

module.exports = {

		//GET methods

	getTasks: async (req,res)=>{
		req.acceptsCharsets('utf-8');
		var tasks = await Task.find();

		res.send(tasks);



	},

		// POST methods

		createTask: async (req,res)=>{
		req.acceptsCharsets('utf-8');
			var headers = req.headers;
			var title = headers['title'];
			var description = headers['description'];

			await Task.create({title : title , description : description}).exec((err)=>{

				if(err != null){

					res.send("Failure while adding task");
				}
				res.send("Added succesfully");





			});


		},
			deleteTask: async (req,res)=>{
		req.acceptsCharsets('utf-8');
		var id = req.headers['id'];

		await Task.destroy({id:id}).exec((err)=>{

						if(err != null){
							res.send("Failure while deleting task");
						}
						res.send("Deleted Successfully");

		})


		}

}