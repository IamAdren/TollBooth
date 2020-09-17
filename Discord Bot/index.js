const Discord = require('discord.js');
const client = new Discord.Client();
const config = require('./config.JS');
const mysql = require('mysql');
const connection = mysql.createConnection(config.mysql);

client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}!`);
    connection.connect(function(err) {
        if (err) {
            console.error('error connecting: ' + err.stack);
            return;
        }
        console.log('Connected as id ' + connection.threadId);
    });
});

client.on('message', message => {
    if (message.channel.type === "dm") return;
    if (message.author.bot) return;

    const prefix = config.prefix;
    const args = message.content.slice(prefix.length).trim().split(/ +/g);
    const command = args.shift().toLowerCase();

    if (message.content.startsWith(prefix + "tollstats")) {
        connection.query(`SELECT * FROM toll_booth_stats`, function (error, results, fields) {
            if (error) throw error;
            const tollEmbed = new Discord.MessageEmbed().setTitle('Toll Booth Stats');
            for (i = 0; i < results.length; i++) {
                tollEmbed.addField('Toll Booth', `${results[i].name}`, false)
                tollEmbed.addField('Successful Vehicles', results[i].successful, true)
                tollEmbed.addField('Failure to Pay', results[i].failure, true)
                tollEmbed.addField('Stolen Vehicles', results[i].stolen, true)
            }
            message.channel.send(tollEmbed);
        });   
    }
});

client.login(config.token);