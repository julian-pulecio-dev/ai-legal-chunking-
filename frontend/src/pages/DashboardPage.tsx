import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { authApi, type MeResponse } from '../api/authApi'

export function DashboardPage() {
  const navigate = useNavigate()
  const { accessToken, logout } = useAuth()
  const [me, setMe] = useState<MeResponse | null>(null)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!accessToken) return
    authApi
      .me(accessToken)
      .then(setMe)
      .catch(() => setError('No se pudo cargar el perfil'))
  }, [accessToken])

  async function handleLogout() {
    await logout()
    navigate('/login')
  }

  return (
    <div className="auth-card">
      <h1>Panel</h1>
      {error && <p className="error">{error}</p>}
      {me ? (
        <ul>
          <li>
            <strong>Email:</strong> {me.email}
          </li>
          <li>
            <strong>Sub:</strong> {me.sub}
          </li>
        </ul>
      ) : (
        !error && <p>Cargando...</p>
      )}
      <button type="button" onClick={handleLogout}>
        Cerrar sesión
      </button>
    </div>
  )
}
