import mongoose from 'mongoose'


const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI, {
            dbName: 'hotelms'
        });
        console.log(`✅ mongoDB connected successfully: ${conn.connection.host}`);
    }
        catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit();
    }
}
 
export default connectDB;