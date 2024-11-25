import useRouteNavigation from '../../hooks/useRouteNavigation';
import Button from '../Button/Button';
import showToast from '../../utils/toastUtil';

const LeaveGameListButton = () => {
  const { redirectToHomePage } = useRouteNavigation();

  const handleLeaveClick = async () => {
    try {
      redirectToHomePage();
    } catch (error) {
      showToast({
        type: 'error',
        message:
          'Error al abandonar el listado de partidas. Intente nuevamente.',
        autoClose: 3000,
      });
      console.error('Error al abandonar el listado de partidas', error);
    }
  };

  return (
    <div className='absolute top-4 left-4 z-50'>
      <Button text={'⭠'} style={'borderButton'} onPress={handleLeaveClick} />
    </div>
  );
};

export default LeaveGameListButton;
