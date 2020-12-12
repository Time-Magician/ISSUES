package com.example.userservice.DaoImpl;

import com.example.userservice.Dao.UserDao;
import com.example.userservice.Entity.Friends;
import com.example.userservice.Entity.Message;
import com.example.userservice.Entity.User;
import com.example.userservice.Repository.FriendsRepository;
import com.example.userservice.Repository.MessageRepository;
import com.example.userservice.Repository.UserRepository;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class UserDaoImpl implements UserDao {
    @Autowired
    UserRepository userRepository;

    @Autowired
    FriendsRepository friendsRepository;

    @Autowired
    MessageRepository messageRepository;

    @Override
    public User getUserById(int userId) {
        return userRepository.getOne(userId);
    }

    @Override
    public User addUser(User user) {
        userRepository.save(user);
        friendsRepository.save(new Friends(user.getUserId(), new ArrayList<>()));
        return user;
    }

    @Override
    public User checkTelDuplicate(String tel) {
        return userRepository.getUserByTelEquals(tel);
    }

    @Override
    public User checkEmailDuplicate(String email) {
        return userRepository.getUserByEmailEquals(email);
    }

    @Override
    public User getUserByTel(String tel) {
        return userRepository.getUserByTelEquals(tel);
    }

    @Override
    public User getUserByEmail(String email){
        return userRepository.getUserByEmailEquals(email);
    }

    @Override
    public List<User> getFriendList(int userId){
        Optional<Friends> friends = friendsRepository.findByUserId(userId);
        List<User> friendList = new ArrayList<>();
        if(friends.isPresent()) {
            List<Integer> friendIdList = friends.get().getFriends();
            for(int f : friendIdList){
                User friend = userRepository.getOne(f);
                friendList.add(friend);
            }
        }
        return friendList;
    }

    @Override
    public User deleteFriend(int userId, int friendId){
        Optional<Friends> f = friendsRepository.findByUserId(userId);
        User friend = userRepository.getOne(friendId);
        if(f.isPresent()) {
            Friends friends = f.get();
            List<Integer> friendIdList = friends.getFriends();
            friendIdList.remove(friendIdList.indexOf(friendId));
            friends.setFriends(friendIdList);
            friendsRepository.save(friends);
        }
        return friend;
    }

    @Override
    public User addFriend(int userId, int friendId){
        Optional<Friends> f = friendsRepository.findByUserId(userId);
        User friend = userRepository.getOne(friendId);
        if(f.isPresent()) {
            Friends friends = f.get();
            List<Integer> friendIdList = friends.getFriends();
            if(!friendIdList.contains(friendId)){
                friendIdList.add(friendId);
            }
            friends.setFriends(friendIdList);
            friendsRepository.save(friends);
        }
        return friend;
    }

    @Override
    public List<Message> getMessages(int userId){
        Optional<List<Message>> messages = messageRepository.findByReceiverId(userId);
        if(messages.isPresent()) {
            return messages.get();
        }
        return null;
    }

    @Override
    public Message addMessage(int senderId, int receiverId, String time, String type, String detail){
        Message message = new Message(senderId, receiverId, time, type, 0, detail);
        messageRepository.save(message);
        return message;
    }

    @Override
    public Message updateMessage(String messageId){
        Optional<Message> message = messageRepository.findById(messageId);
        if(message.isPresent()) {
            Message m = message.get();
            m.setStatus(1);
            messageRepository.save(m);
            return m;
        }
        return null;
    }
}
