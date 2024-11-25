const Button = ({
  text,
  onPress,
  style,
  type = 'button',
  isDisabled = false,
}) => {
  const baseClasses = 'lekton-bold rounded-xl transition-all';
  const typeClasses = {
    homeButton:
      'text-3xl w-80 py-6 bg-white text-black hover:bg-black hover:text-white',
    formButton:
      'text-xl p-4 bg-white text-black hover:bg-black hover:text-white',
    borderButton:
      'text-xl bg-white text-black px-4 py-1 mt-2 border-white border-2 hover:bg-transparent hover:text-white hover:border-white',
    lobbyButton_disabled:
      'pc:w-[18rem] pc:h-[4.375rem] pc:text-3xl border-2 border-[#f1f1f1] bg-[#f1f1f1] text-[#C0C0C0] cursor-not-allowed disabled w-[14rem] h-[2.375rem] text-xl',
    lobbyButton_init:
      'pc:w-[18rem] pc:h-[4.375rem] pc:text-3xl border-2 border-[#f1f1f1] bg-[#f1f1f1] text-[#0c0c0c] hover:bg-transparent hover:text-[#f1f1f1] w-[14rem] h-[2.375rem] text-xl',
    lobbyButton_leave:
      'pc:w-[18rem] pc:h-[4.375rem] pc:text-3xl border-2 border-[#ee6055] bg-[#ee6055] text-[#0c0c0c] hover:bg-transparent hover:text-[#ee6055] w-[14rem] h-[2.375rem] text-xl',
    gameButton_endTurn:
      'pc:w-[16rem] pc:h-[4.375rem] pc:text-2xl border-2 border-[#f1f1f1] bg-[#f1f1f1] text-[#0c0c0c] hover:bg-transparent hover:text-[#f1f1f1] w-[14rem] h-[2.375rem] text-xl',
    gameButton_leave:
      'fixed top-3 right-3 w-11 h-11 rounded text-2xl border-2 border-[#ee6055] bg-[#ee6055] text-[#0c0c0c] hover:bg-transparent hover:text-[#ee6055]',
    gameButton_play:
      'pc:w-[16rem] pc:h-[4.375rem] pc:text-2xl border-2 border-[#000000] bg-[#000000] text-[#f1f1f1] hover:bg-transparent hover:text-[#f1f1f1] w-[14rem] h-[2.375rem] text-xl',
    gameButton_cancelMovement:
      'pc:w-[16rem] pc:h-[4.375rem] pc:text-2xl border-2 border-[#ee6055] bg-[#ee6055] text-[#0c0c0c] hover:bg-transparent hover:text-[#ee6055] w-[14rem] h-[2.375rem] text-xl',
    reset_filter:
      'flex justify-center items-center text-xl h-10 p-4 bg-white text-black hover:bg-black hover:text-white z-10',
  };

  const buttonClasses = `${baseClasses} ${typeClasses[style]}`;

  return (
    <button
      type={type}
      onClick={onPress}
      className={buttonClasses}
      disabled={isDisabled}
    >
      {text}
    </button>
  );
};

export default Button;
