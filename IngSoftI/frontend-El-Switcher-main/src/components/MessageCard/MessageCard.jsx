const MessageCard = ({ type, message }) => {
  const typeClasses = {
    error: 'bg-red-500',
    info: 'bg-[#0C0C0C]',
  };

  return (
    <div className='fixed inset-0 flex justify-center items-center'>
      <div
        className={`${typeClasses[type]} font-semibold text-white text-xl p-5 rounded-lg shadow-lg animate-bounce`}
      >
        {message}
      </div>
    </div>
  );
};

export default MessageCard;
